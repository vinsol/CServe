class Ticket < ActiveRecord::Base

  include AASM

  require 'securerandom'

  validates :email, :subject, :description, presence: true
  validates :subject, length: { maximum: 100 }

  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :company
  belongs_to :admin

  accepts_nested_attributes_for :attachments

  after_create :send_feedback_mail

  before_create :set_unique_id

  delegate :name, :subdomain, :support_email, to: :company, prefix: true
  delegate :email, :name, to: :admin, prefix: true

  paginates_per 20

  scope :unassigned, -> { where(state: :unassigned, admin_id: nil) }

  aasm column: :state, whiny_transitions: false do
    state :unassigned
    state :assigned
    state :resolved
    state :closed

    event :assign do
      after { send_mail(:notify_update_status) }
      transitions from: :unassigned, to: :assigned
    end

    event :resolve do
      after { send_mail(:notify_resolving_status) }
      transitions from: :assigned, to: :resolved
    end

    event :close do
      after { send_mail(:notify_closing_status) }
      transitions from: [:resolved, :assigned], to: :closed
    end

    event :reopen do
      after { send_mail(:notify_reopening_status) }
      transitions from: :resolved, to: :assigned
    end

    event :reassign do
      after do
        send_mail(:assignment_notification)
        send_mail(:notify_update_status)
      end
      transitions from: :assigned, to: :assigned
    end
  end

  def self.find_ticket_and_create_comment(company_name, ticket_id, ticket_subject, mail_text, message)
    company = Company.find_by(support_email: message.to.first)
    if company && company.confirmation_token.nil?
      mail_body_array = mail_text.split('Write ABOVE THIS LINE to post a reply')
      ticket_unique_id = mail_body_array.second.split('#').second
      mail_text = mail_body_array.first.split('On')
      mail_text.delete(mail_text.last)
      mail_text = mail_text.join
      ticket = company.tickets.find_by(unique_id: ticket_unique_id)
      if ticket && !ticket.closed? && mail_text.empty?
        ticket.comments.build(text: mail_text, commenter_email: message.from.first, public: 'true').save
      end
    end
  end

  def self.create_ticket_from_mail(email_text, message)
    company = Company.find_by(support_email: message.to.first)
    if company && company.confirmation_token.nil?
      company.tickets.build(description: email_text,
                            state: :unassigned,
                            subject: message.subject,
                            email: message.from.first)
    end
  end

  private

    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end

    def send_mail(mailer_method)
      NotifierMailer.public_send(mailer_method, self).deliver
    end

    def set_unique_id
      self.unique_id = SecureRandom.hex
    end

end

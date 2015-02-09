class Ticket < ActiveRecord::Base

  include AASM

  validates :email, :subject, :description, presence: true
  validates :subject, length: { maximum: 100 }

  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :company
  belongs_to :admin

  accepts_nested_attributes_for :attachments

  after_create :send_feedback_mail

  delegate :name, :subdomain, to: :company, prefix: true
  delegate :email, :name, to: :admin, prefix: true

  paginates_per 20

  #FIXME_AB: I think we should make this scope independent of company_id. Because we should be calling it as current_company.tickets.unassigned.. If we need to call it otherwise we can use it like Ticket.unassigned.where()
  #FIXME_AB: Also I think it should just check for admin_id not for state. We should have another scope for new. current_company.tickets.new.unassigned
  scope :unassigned, ->(company_id) { where(state: 'new', company_id: company_id, admin_id: nil) }

  aasm column: :state, whiny_transitions: false do
    state :new
    state :assigned
    state :resolved
    state :closed

    event :assign do
      after { send_mail(:notify_update_status) }
      transitions from: :new, to: :assigned
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

  private

    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end

    def send_mail(mailer_method)
      NotifierMailer.public_send(mailer_method, self).deliver
    end

end

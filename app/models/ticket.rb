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
  after_update :send_assignment_mail, unless: -> { state_changed? }

  delegate :name, :subdomain, to: :company, prefix: true

  paginates_per 20

  scope :unassigned, ->(company_id) { where(state: 'new', company_id: company_id, admin_id: nil) }

  aasm column: :state, whiny_transitions: false do
    state :new
    state :assigned
    state :resolved
    state :closed

    event :assign do
      after { send_mail(:notify_update) }
      transitions from: :new, to: :assigned
    end

    event :resolve do
      after { send_mail(:notify_result) }
      transitions from: :assigned, to: :resolved
    end

    event :close do
      after { send_mail(:notify_closing_status) }
      transitions from: [:assigned, :resolved], to: :closed
    end

    event :reopen do
      after { send_mail(:notify_reopening_status) }
      transitions from: :closed, to: :assigned
    end
  end

  private

    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end

    def send_mail(mailer_method)
      NotifierMailer.public_send(mailer_method, self).deliver
    end

    def send_assignment_mail
      NotifierMailer.assignment_notification(self).deliver
    end

end

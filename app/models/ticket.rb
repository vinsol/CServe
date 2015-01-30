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

  paginates_per 20

  scope :unassigned, ->(company_id) { where(state: 'new', company_id: company_id, admin_id: nil) }

  aasm column: :state, whiny_transitions: false do
    state :new
    state :assigned
    state :resolved
    state :closed

    event :assign do
      after { send_update_mail }
      transitions from: :new, to: :assigned
    end

    event :resolve do
      after { send_resolving_mail }
      transitions from: :assigned, to: :resolved
    end

    event :close do
      after { send_closing_mail }
      transitions from: [:assigned, :resolved], to: :closed
    end

    event :reopen do
      after { send_reopening_mail }
      transitions from: :closed, to: :assigned
    end
  end

  private

    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end

    def send_update_mail
      NotifierMailer.notify_update(self).deliver
    end

    def send_resolving_mail
      NotifierMailer.notify_result(self).deliver
    end

    def send_closing_mail
      NotifierMailer.notify_closing_status(self).deliver
    end

    def send_reopening_mail
      NotifierMailer.notify_reopening_status(self).deliver
    end

end

class Ticket < ActiveRecord::Base

  validates :email, :subject, :description, presence: true
  validates :subject, length: { maximum: 100 }

  has_many :attachments, dependent: :destroy

  has_many :comments, dependent: :destroy

  belongs_to :company

  belongs_to :admin

  accepts_nested_attributes_for :attachments

  after_create :send_feedback_mail

  delegate :name, :subdomain, to: :company, prefix: true

  scope :unassigned, ->(company_id) { where(state: 'new', company_id: company_id, admin_id: nil) }

  private

    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end

end

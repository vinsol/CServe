class Ticket < ActiveRecord::Base
  validates :email, :subject, :description, presence: true
  has_many :attachments
  belongs_to :company
  accepts_nested_attributes_for :attachments
  after_create :send_feedback_mail
  delegate :name, :subdomain, to: :company, prefix: true
  has_many :comments, dependent: :destroy

  private
    def send_feedback_mail
      UserMailer.feedback_instructions(self).deliver
    end
end
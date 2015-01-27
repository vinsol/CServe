class Ticket < ActiveRecord::Base
  validates :email, :subject, :description, presence: true
  validates :subject, length: { maximum: 100 }
  has_many :attachments
  belongs_to :company
  accepts_nested_attributes_for :attachments
end
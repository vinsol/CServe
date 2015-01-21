class Ticket < ActiveRecord::Base
  validates :email, :subject, :description, presence: true
  has_many :attachments
  belongs_to :company
  accepts_nested_attributes_for :attachments
end
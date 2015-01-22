class Comment < ActiveRecord::Base

  validates :text, presence: true
  belongs_to :ticket

  def set_commenter_email(admin, ticket)
    self.commenter_email = admin ? admin.email : ticket.email
  end
end
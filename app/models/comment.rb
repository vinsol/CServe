class Comment < ActiveRecord::Base

  validates :text, presence: true

  belongs_to :ticket

  after_create :notify_user, if: -> { kind == 'public' }

  scope 'for_user', -> { where(kind: 'public') }

  def set_commenter_email(admin, ticket)
    self.commenter_email = admin ? admin.email : ticket.email
  end

  private
    def notify_user
      ticket = self.ticket
      NotifierMailer.notify_comment(self, ticket).deliver unless ticket.email == self.commenter_email
    end

end

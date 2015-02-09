class Comment < ActiveRecord::Base

  validates :text, presence: true

  #FIXME_AB: use require true
  belongs_to :ticket

  #FIXME_AB: make this a boolean field
  #FIXME_AB: Also should be like if: "public?"
  after_create :notify_user, if: -> { kind == 'public' }

  #FIXME_AB: use symbol. Also rename it to public
  scope 'for_user', -> { where(kind: 'public') }

  def set_commenter_email(admin, ticket)
    self.commenter_email = admin ? admin.email : ticket.email
  end

  private
    def notify_user
      ticket = self.ticket
      #FIXME_AB: You should not pass object to delayed job. This may result in handler overflow when object converted to YML to save in db. So you should pass ids.
      NotifierMailer.notify_comment(self, ticket).deliver unless ticket.email == self.commenter_email
      #FIXME_AB: Extract condition in above line as a separate method. Moreover I think we should send email to everybody, including the commenter for his reference.
    end

end

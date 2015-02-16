class Comment < ActiveRecord::Base

  validates :text, presence: true
  validates :public, inclusion: { in: [true, false] }

  belongs_to :ticket, required: true

  after_create :notify_user, if: :public?

  scope :for_user, -> { where(public: true) }

  before_save :replace_new_line

  def set_commenter_email(admin, ticket)
    self.commenter_email = admin ? admin.email : ticket.email
  end

  private
    def notify_user
      ticket = self.ticket
      NotifierMailer.notify_comment(self, ticket).deliver unless ticket.email == self.commenter_email
    end

    def replace_new_line
      text.gsub!(/\n/, '<br />')
    end

end

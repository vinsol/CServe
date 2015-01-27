class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: "[Request received](#{ @ticket.subject })")
  end

end
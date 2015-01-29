class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: " Update on (#{ @ticket.subject })")
  end

end
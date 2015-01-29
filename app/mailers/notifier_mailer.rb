class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: " Update on (#{ @ticket.subject })")
  end

  def notify_update(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

end

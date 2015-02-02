class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: " Update on (#{ @ticket.subject })")
  end

  def notify_update(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

  def notify_result(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

  def notify_closing_status(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

  def notify_reopening_status(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

  def assignment_notification(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

end

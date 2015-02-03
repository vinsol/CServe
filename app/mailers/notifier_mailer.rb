class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: " Update on (#{ @ticket.subject })")
  end

  %w(update resolving closing reopening).each do |_method_|
    define_method("notify_#{ _method_ }_status") do |ticket|
      @ticket = ticket
      mail(to: @ticket.email, subject: "(##{ @ticket.id }) @ticket.subject")
    end
  end

  def assignment_notification(ticket)
    @ticket = ticket
    mail(to: @ticket.admin_email, subject: "(##{ @ticket.id }) @ticket.subject")
  end

end

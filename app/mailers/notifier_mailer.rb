class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email,
      subject: t('notifier.notify_comment',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

  %w(update resolving closing reopening).each do |_method_|
    define_method("notify_#{ _method_ }_status") do |ticket|
      @ticket = ticket
      mail(to: @ticket.email,
        subject: t("notifier.notify_#{ _method_ }_status",
          ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
    end
  end

  def assignment_notification(ticket)
    @ticket = ticket
    mail(to: @ticket.admin_email,
      subject: t('notifier.assignment_notification',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

end

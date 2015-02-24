class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
    headers {
      ticket_unique_id: ticket.id
    }
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email,
      reply_to: "#{ @ticket.company_support_email }",
      subject: t('notifier.notify_comment',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

  %w(update resolving closing reopening).each do |_method_|
    define_method("notify_#{ _method_ }_status") do |ticket|
      headers {
        ticket_unique_id: ticket.id
      }
      @ticket = ticket
      mail(to: @ticket.email,
        reply_to: "#{ @ticket.company_support_email }",
        subject: t("notifier.notify_#{ _method_ }_status",
          ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
    end
  end

  def assignment_notification(ticket)
    headers {
      ticket_unique_id: ticket.id
    }
    @ticket = ticket
    mail(to: @ticket.admin_email,
      reply_to: "#{ @ticket.company_support_email }",
      subject: t('notifier.assignment_notification',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

  def forward_confirmation_instructions(code, subject, email_id)
    @code = code
    mail(to: email_id,
      subject: 'Forwarding Confirmation')
  end

end

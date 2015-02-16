class UserMailer < ApplicationMailer

  def feedback_instructions(ticket)
    ticket.attachments.each do |attachment|
      attachments[attachment.document_file_name] = File.read(attachment.document.path)
    end
    @ticket = ticket
    mail(to: @ticket.email,
      subject: t('user.feedback_instructions',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

end

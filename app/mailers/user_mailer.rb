class UserMailer < ApplicationMailer

  def feedback_instructions(ticket)
    @ticket = ticket
    mail(to: @ticket.email,
      subject: t('user.feedback_instructions',
        ticket: @ticket.id, company: @ticket.company_name, subject: @ticket.subject))
  end

end

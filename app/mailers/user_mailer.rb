class UserMailer < ApplicationMailer

  def feedback_instructions(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: "[Request received] (#{ @ticket.subject })")
  end

end

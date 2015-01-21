class UserMailer < ActionMailer::Base
  helper :subdomain
  default from: MAIL_ID
  def feedback_instructions(ticket)
  	debugger
    @ticket = ticket
    mail(to: @ticket.email, subject: "[Request received] (#{ @ticket.subject })")
  end
end

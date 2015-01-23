class NotifierMailer < ApplicationMailer

  def notify_comment(comment, ticket)
  	debugger
    @ticket, @comment = ticket, comment
    mail(to: @ticket.email, subject: "[Request received](#{ @ticket.subject })")
  end

end
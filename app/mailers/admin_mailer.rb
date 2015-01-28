class AdminMailer < ApplicationMailer

  def set_password_instructions(admin, token)
  	debugger
    @admin, @token = admin, token
    mail(to: @admin.unconfirmed_email, subject: 'Set Password for your account')
  end

end

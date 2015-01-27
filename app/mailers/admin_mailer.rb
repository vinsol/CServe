class AdminMailer < ApplicationMailer

  def set_password_instructions(admin, token)
    @admin = admin
    @token = token
    mail(to: @admin.email, subject: 'Set Password for your account')
  end

end

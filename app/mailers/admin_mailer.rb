class AdminMailer < ApplicationMailer

  def set_password_instructions(admin, token)
    @admin, @token = admin, token
    mail(to: @admin.email, subject: 'Set Password for your account')
  end

end

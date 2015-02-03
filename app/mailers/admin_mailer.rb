class AdminMailer < ApplicationMailer

  def set_password_instructions(admin, token)
    @admin, @token = admin, token
    mail(to: @admin.email, subject: t('admin.set_password_instructions'))
  end

end

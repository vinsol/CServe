class AdminMailer < ActionMailer::Base
  helper :subdomain
  default from: 'CServe <akshay.chhikara@vinsol.com>'

  def set_password_instructions(admin, token)
    @admin = admin
    @token = token
    mail(to: @admin.email, subject: 'Set Password for your account')
  end
end

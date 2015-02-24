class CompanyMailer < ApplicationMailer

  def confirmations_instructions(company, token)
    @company, @token = company, token
    mail(to: @company.support_email,
      reply_to: "#{ @company.support_email }",
      subject: t('company.confirmations_instructions'))
  end

end

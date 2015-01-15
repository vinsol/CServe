class Admins::SessionsController < Devise::SessionsController
 before_filter :check_subdomain?, only: [:new]

  protected

  def check_subdomain?
    subdomain = request.subdomain
    if ['www', 'ftp', 'ssh'].include?(subdomain)
      return redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host])
    elsif subdomain.blank? || Company.find_by(subdomain: subdomain).nil?
      return redirect_to new_company_url(host: Rails.application.config.action_mailer.default_url_options[:host]), alert: 'Get Registered First'
    end
  end

end

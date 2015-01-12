class Admins::SessionsController < Devise::SessionsController
 before_filter :check_subdomain?, only: [:new]

  protected

  def check_subdomain?
    subdomain = request.subdomain
    if subdomain == 'www'
      redirect_to root_url
    elsif subdomain.blank? || Company.find_by(subdomain: subdomain).nil?
      redirect_to new_admin_registration_url(host: Rails.application.config.action_mailer.default_url_options[:host]), alert: 'Get Registered First'
    end
  end

end

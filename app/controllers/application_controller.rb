class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_company

  protected

  def after_sign_in_path_for(resource)
    admins_path
  end

  def after_sign_out_path_for(resource)
    sign_in_path
  end

  def validate_subdomain
    subdomain = request.subdomain
    if subdomain.present?
      if subdomain == 'www'
        redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host])
      elsif Company.find_by(subdomain: subdomain).nil?
        flash[:alert] = 'Get Registered First'
        redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host])
      end
    end
  end

  def current_company
    company = Company.find_by(subdomain: request.subdomain)
    unless company
      redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host]),
      alert: 'Company not found.'
    end
    company
  end

end

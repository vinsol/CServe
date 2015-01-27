class Admins::SessionsController < Devise::SessionsController
  before_action :check_subdomain?, only: [:new]
  before_action :check_admin_company_and_status, only: [:create]

  protected

  def check_subdomain?
    subdomain = request.subdomain
    if subdomain == 'www'
      redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host])
    elsif subdomain.blank? || Company.find_by(subdomain: subdomain).nil?
      flash[:alert] = 'Get Registered First'
      redirect_to root_url(host: Rails.application.config.action_mailer.default_url_options[:host])
    end
  end

  def check_admin_company_and_status
    if params[:admin][:email].present?
      admin = Admin.where(email: params[:admin][:email]).first
      if admin.nil? || admin.subdomain != request.subdomain
        redirect_to sign_in_path, alert: 'You are not authorized' and return
      end
      redirect_to sign_in_path, alert: 'Your account has been disabled.Contact your company Admin' unless admin.active?
    end
  end

end

class Admins::SessionsController < Devise::SessionsController
  layout 'admins', only: [:new]
  before_action :validate_subdomain
  before_action :check_admin_company_and_status, only: [:create]

  protected

  def check_admin_company_and_status
    if params[:admin][:email].present?
      admin = current_company.admins.find_by(email: params[:admin][:email])
      if admin.nil? || admin.subdomain != request.subdomain
        redirect_to sign_in_path, alert: 'You are not authorized' and return
      end
      redirect_to sign_in_path, alert: 'Your account has been disabled.Contact your company Admin' unless admin.enabled?
    end
  end

end

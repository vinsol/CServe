class Admins::RegistrationsController < Devise::RegistrationsController

  layout 'admins', only: [:edit, :update]

  skip_before_filter :require_no_authentication, only: :create

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:company_id, :name]
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def after_inactive_sign_up_path_for(resource)
    root_url
  end

  def after_update_path_for(resource)
    admins_path
  end

end

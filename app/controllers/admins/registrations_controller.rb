class Admins::RegistrationsController < Devise::RegistrationsController

  layout 'admins', only: [:edit, :update]

  skip_before_filter :require_no_authentication, only: [:create]

  protected
  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:company_id, :name]
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    root_url
  end

  def after_update_path_for(resource)
    admins_path
  end

end

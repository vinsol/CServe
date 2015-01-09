class Admins::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

  protected
  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:role, :company_id]
  end

  # You can put the params you want to permit in the empty array.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << [:role, :company_id]
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

end

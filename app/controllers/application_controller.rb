class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  protected

  def after_sign_in_path_for(resource)
    admins_path
  end

  def after_sign_out_path_for(resource)
    sign_in_path
  end

end

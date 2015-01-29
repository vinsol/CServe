class Admins::PasswordsController < Devise::PasswordsController

  before_action :check_validity_of_token?, only: :edit

  private
  def check_validity_of_token?
    original_token       = params[:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    recoverable = resource_class.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
    if recoverable.invalid?
      flash[:alert] = 'Link expired get new link again'
      redirect_to new_admin_password_path
    end
  end

end

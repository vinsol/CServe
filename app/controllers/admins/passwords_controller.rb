class Admins::PasswordsController < Devise::PasswordsController

  def edit
    self.resource = resource_class.reset_password_by_token(params)
    if resource.errors.empty?
      super
    else
      flash[:alert] = 'Link expired get new link again'
      redirect_to new_admin_password_path
    end
  end

end
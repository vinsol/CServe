class Admins::SessionsController < Devise::SessionsController
 before_filter :check_subdomain?, only: [:new]

  protected

  def check_subdomain?
    if request.subdomain.blank? || Company.find_by(subdomain: request.subdomain).nil?
      redirect_to new_company_path, alert: 'Get Registered First'
    end
  end

end

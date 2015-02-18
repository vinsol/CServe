module AdminsHelper

  def check_for_company_or_current_admin(admin)
    admin.company_admin? || admin == current_admin
  end
 
end

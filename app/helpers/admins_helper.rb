module AdminsHelper

  def link_to_toggle_status(admin)
    action = admin.enabled? ? 'disable' : 'enable'
    path = "#{ action }_admin_path"
    link_to(action.capitalize, public_send(path, admin), method: :patch,
      data: { confirm: "Are you sure you want to #{ action } #{ admin.name }?." })
  end

  def check_for_company_or_current_admin(admin)
    admin.company_admin? || admin == current_admin
  end
 
end

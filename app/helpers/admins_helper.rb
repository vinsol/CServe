module AdminsHelper
  def link_to_toggle_status(admin)
    action = admin.active ? 'Disable' : 'Enable'
    link_to(action, change_state_admin_path(admin), method: :patch)
  end
end

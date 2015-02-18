module ApplicationHelper

  def pagination_info(object)
    if (object && object.length > 0)
     "Showing #{ object.offset_value + 1 } - #{ object.offset_value + object.length } of #{ object.total_count }"
   end
  end

  def add_active_class(selected_item)
    controller_name == selected_item ? 'nav-active' : ''
  end

  def link_to_toggle_status(object)
    action = object.enabled? ? 'disable' : 'enable'
    path = controller_name.eql?('admins') ? "#{ action }_admin_path" : "#{ action }_admins_category_path"
    link_to(action.capitalize, public_send(path, object), method: :patch,
      data: { confirm: "Are you sure you want to #{ action } #{ object.name }?." })
  end

end

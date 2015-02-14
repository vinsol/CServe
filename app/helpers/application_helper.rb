module ApplicationHelper

  def pagination_info(object)
    if (object && object.length > 0)
     "Showing #{ object.offset_value + 1 } - #{ object.offset_value + object.length } of #{ object.total_count }"
   end
  end

  def inline_error(object, property)
    error = object.errors[property]
    content_tag(:span, error.join(','), class: 'errors') if error.present?
  end

  def add_active_class(controller_name, selected_item)
    controller_name == selected_item ? 'nav-active' : ''
  end

end

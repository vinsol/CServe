module ApplicationHelper
  def pagination_info(object)
    if (object && object.length > 0)
     "Showing #{ object.offset_value + 1 } - #{ object.offset_value + object.length } of #{ object.total_count }"
   end
  end

  def display(error)
    content_tag(:span, error.first, class: 'errors') if error.present?
  end
end

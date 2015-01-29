module ApplicationHelper

  def pagination_info(object)
    if (object && object.length > 0)
     "Showing #{ object.offset_value + 1 } - #{ object.offset_value + object.length } of #{ object.total_count }"
   end
  end

  def display(error)
    content_tag(:span, error.join(','), class: 'errors') if error.present?
  end

  def company_name
    Company.find_by(subdomain: request.subdomain).name.capitalize
  end

end

module ArticleHelper

  def sanitize_and_truncate(description)
    if (description.length > 30)
      sanitize(description).truncate(30).gsub(/<.+>/, '')
    else
      sanitize(description)
    end
  end

  def category_list
    current_company.categories.map do |category|
      [category.name.capitalize, category.id]
    end
  end

end

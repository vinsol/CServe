module ArticleHelper

  def sanitize_and_truncate(description)
    if (description.length > 30)
      sanitize(description).truncate(30).gsub(/<.+>/, '')
    else
      sanitize(description)
    end
  end

end

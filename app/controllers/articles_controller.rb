class ArticlesController < BaseController

  layout 'admins'

  skip_before_action :authenticate_admin!

  def index
    @search = current_company.articles
                        .published
                        .search(params[:q])
    @articles = @search.result
                       .order('updated_at DESC')
                       .page(params[:page])
  end

end

class ArticlesController < BaseController

  #FIXME_AB: can we move this layout line in BaseController itself?
  #FIXME_AB: I think it is a user facing controller so why we are using admins layout
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

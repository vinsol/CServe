class ArticlesController < ApplicationController

  layout 'user'

  before_action :load_article, only: :show

  def index
    @search = current_company.articles
                             .published
                             .search(params[:q])
    @articles = @search.result
                       .order('updated_at DESC')
                       .page(params[:page])
  end

  private
    def load_article
      @article =  current_company.articles.find_by(id: params[:id])
      redirect_to request.referer, alert: 'Article not found.' unless @article
    end

end

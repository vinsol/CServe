class Admins::ArticlesController < BaseController

  layout 'admins'

  skip_before_action :authenticate_admin!
  before_action :load_article, only: [:edit, :update, :destroy, :publish, :unpublish, :show]

  def new
    @article = current_company.articles.build
  end

  def index
    @articles = current_company.articles
                               .order('updated_at DESC')
                               .page(params[:page])
  end

  def create
    @article = current_company.articles.build(article_params.merge(admin_id: current_admin.id))
    if @article.save
      redirect_to admins_articles_path, notice: 'Article Sucessfully created'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to admins_articles_path, notice: 'Article Updated'
    else
      render :edit
    end
  end

  def destroy
    if @article.destroy
      redirect_to admins_articles_path, notice: 'Article Sucessfully Deleted'
    else
      redirect_to admins_articles_path, alert: 'Unable to delete Article'
    end
  end

  %w(publish unpublish).each do |_method_|
    define_method _method_ do
      @article.public_send("#{ _method_ }!")
      redirect_to admins_article_path(@article), notice: "Article #{ _method_ }ed Successfully"
    end
  end

  def published
    @search = current_company.articles
                        .published
                        .search(params[:q])
    @articles = @search.result
                       .order('updated_at DESC')
                       .page(params[:page])
  end

  private

    def article_params
      params.require(:article).permit(:title, :description)
    end

    def load_article
      @article =  current_company.articles.find_by(id: params[:id])
      redirect_to admins_articles_path, alert: 'Article not found.' unless @article
    end

    def redirect_if_invalid_transition
      unless @article.public_send("may_#{ params[:action] }?")
        redirect_to admins_articles_path, alert: 'Cannot process request'
      end
    end

end

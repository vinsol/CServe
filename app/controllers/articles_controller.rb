class ArticlesController < ApplicationController

  layout 'admins'


  before_action :authenticate_admin!
  before_action :load_company, only: [:edit , :create, :update, :new]
  before_action :load_article, only: [:edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def index
    @articles = Article.where(company_id: current_admin.company_id)
                       .order('updated_at DESC')
                       .page(params[:page])
  end

  def create
    @article = @company.articles.build(article_params)
    @article.set_admin(current_admin)
    if @article.save
      redirect_to articles_path, notice: 'Article Sucessfully created'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to articles_path, notice: 'Article Updated'
    else
      render :edit
    end
  end

  def destroy
    if @article.delete
      redirect_to articles_path, notice: 'Article Sucessfully Deleted'
    else
      redirect_to articles_path, alert: 'Unable to delete Article'
    end
  end

  private

    def article_params
      params.require(:article).permit(:title, :description)
    end

    def load_company
      @company = Company.find_by(subdomain: request.subdomain)
      redirect_to root_path, alert: 'Company not found.' unless @company
    end

    def load_article
      @article =  Article.find_by(id: params[:id])
      redirect_to articles_path, alert: 'Article not found.' unless @article
    end

end

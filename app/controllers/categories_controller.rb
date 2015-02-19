class CategoriesController < ApplicationController

  layout 'user'

  before_action :validate_subdomain
  before_action :load_category, only: :show

  def index
    @categories = current_company.categories
                                 .page(params[:page])
  end

  def show
    @articles = @category.articles
                         .published
                         .page(params[:page])
  end

  private
    def load_category
      @category =  current_company.categories.find_by(id: params[:id])
      redirect_to categories_path, alert: 'Category not found.' unless @category
    end

end

class Admins::CategoriesController < BaseController

  layout 'admins'

  before_action :load_category, only: [:edit, :update, :enable, :disable]

  def new
    @category = current_company.categories.build
  end
  
  def index
    @categories = current_company.categories
                                .order('updated_at DESC')
                                .page(params[:page])
  end

  def create
    @category = current_company.categories.build(category_params)
    if @category.save
      redirect_to admins_categories_path, notice: "#{ @category.name.capitalize } Sucessfully created"
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admins_categories_path, notice: 'Category Updated'
    else
      render :edit
    end
  end

  def disable
    @category.update(enabled: false)
    redirect_to request.referer, notice: "#{ @category.name } Disabled"
  end

  def enable
    @category.update(enabled: true)
    redirect_to request.referer, notice: "#{ @category.name } Enabled"
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def load_category
      @category =  current_company.categories.find_by(id: params[:id])
      redirect_to admins_articles_path, alert: 'Category not found.' unless @category
    end

end

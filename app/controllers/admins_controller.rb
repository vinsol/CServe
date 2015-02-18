class AdminsController < BaseController

  before_action :load_admin, only: [:change_state, :edit, :update, :disable, :enable]
  before_action :redirect_if_company_admin, only: [:edit]


  def index
    @admins = current_company.admins.order(:name).page(params[:page])
  end

  def new
    @admin = current_company.admins.build
  end

  def create
    @admin = current_company.admins.build(admin_params)
    if @admin.save
      redirect_to admins_path, notice: "#{ @admin.name } added"
    else
      render :new
    end
  end

  def update
    if @admin.update(update_admin_params)
      redirect_to admins_path, notice: "#{ @admin.name } Updated Successfully"
    else
      render :edit
    end
  end

  def disable
    @admin.update(enabled: false)
    redirect_to request.referer, notice: 'Admin Disabled'
  end

  def enable
    @admin.update(enabled: true)
    redirect_to request.referer, notice: 'Admin Enabled'
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end

  def update_admin_params
    admin_params.permit(:name)
  end

  def load_admin
    @admin = current_company.admins.find_by(id: params[:id])
    redirect_to admins_path, alert: 'No such Admin' if @admin.nil?
  end

  def redirect_if_company_admin
    if @admin.company_admin? && !current_admin.company_admin?
      redirect_to admins_path, alert: 'Cannot Edit Company Admin'
    end
  end

end

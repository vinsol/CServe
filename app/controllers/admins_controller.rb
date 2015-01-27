class AdminsController < ApplicationController

  before_action :authenticate_admin!

  before_action :load_admin, only: [:change_state, :edit, :update]

  def index
    @admins = Admin.where.not(id: current_admin.id).where(company_id: current_admin.company_id).order(:name).page(params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = current_admin.company.admins.build(admin_params)
    if @admin.save
      redirect_to admins_path, notice: 'New Admin added'
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_path, notice: ' Admin Updated Successfully'
    else
      render :edit
    end
  end

  def change_state
    @admin.toggle!(:active)
    redirect_to admins_path, notice: 'Admin Updated'
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end

  def load_admin
    @admin = Admin.where(id: params[:id]).first
    redirect_to admins_path if @admin.nil? || @admin.subdomain != request.subdomain
  end

end

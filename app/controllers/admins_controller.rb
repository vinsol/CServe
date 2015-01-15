class AdminsController < ApplicationController

  before_filter :authenticate_admin!, only: [:index]

  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @company = Company.where(id: current_admin.company.id).first
    @admin = @company.admins.build(admin_params)
    if @admin.save_without_confirmation
      redirect_to admins_path, notice: 'New agent added'
    else
      render :new
    end
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    @admin.name = name_param[:name]
    if @admin.save
      redirect_to admins_path, notice: 'Profile Edited'
    else
      render :edit
    end
  end

  def change_state
    @admin = Admin.where(id: params[:id].to_i).first
    @admin.toggle!(:active)
    redirect_to admins_path, notice: 'Admin Updated'
  end

  private

  def admin_params
    params[:admin].permit(:name, :email)
  end

  def name_param
    params[:admin].permit(:name)
  end

end

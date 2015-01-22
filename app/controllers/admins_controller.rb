class AdminsController < ApplicationController

  before_action :authenticate_admin!, only: [:index, :edit, :new]
  before_action :load_admin_or_redirect, only: [:change_state, :edit, :update]
  before_action :set_admin, only: [:create, :new]

  def index
    @admins = Admin.where.not(id: current_admin.id).where(company_id: current_admin.company_id).order(:name).page(params[:page])
  end

  def create
    @admin.company_id = current_admin.company_id
    if @admin.save_without_confirmation
      redirect_to admins_path, notice: 'New Admin added'
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_path, notice: 'Updated Successfully'
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
    params.fetch(:admin, {}).permit(:name, :email)
  end

  def load_admin_or_redirect
    @admin = Admin.find_by(id: params[:id])
    redirect_to admins_path if @admin.nil? || @admin.subdomain != request.subdomain
  end

  def set_admin
    @admin = Admin.new(admin_params)
  end

end

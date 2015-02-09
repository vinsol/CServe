class AdminsController < ApplicationController

  before_action :authenticate_admin!
  before_action :load_admin, only: [:change_state, :edit, :update]
  before_action :redirect_if_company_admin, only: [:edit]


  def index
    #FIXME_AB: use associations. current_company.admins.where
    @admins = Admin.where(company_id: current_admin.company_id).order(:name).page(params[:page])
  end

  def new
    #FIXME_AB: current_admin.admins.build
    @admin = Admin.new
  end

  def create
    #FIXME_AB: current_company.admins.build
    @admin = current_admin.company.admins.build(admin_params)
    if @admin.save
      #FIXME_AB: use the newly created admin's name in the message
      redirect_to admins_path, notice: 'New Admin added'
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      #FIXME_AB: use admins name in the message
      redirect_to admins_path, notice: ' Admin Updated Successfully'
    else
      render :edit
    end
  end

  #FIXME_AB: As a good practice you should have two dedicated method for enable and disable. And dont use toggle. Use @admin.enable! or @admin.disable!
  def change_state
    @admin.toggle!(:active)
    #FIXME_AB: use admin's name in the message
    redirect_to admins_path, notice: 'Admin Updated'
    #FIXME_AB: Can we try enabling/disabling with ajax. I am redirect to page 1 if I am disabling admin on page 4. if not ajax, I should be back on the same page
  end

  private

  def admin_params
    #FIXME_AB: Update form don't have email. so if I add an email field from firebug I can update the email. Also there is no check in the model that email can't be updated. Hiding things from views doesn't make sense until we have a check for them in the backend
    params.require(:admin).permit(:name, :email)
  end

  def load_admin
    #FIXME_AB: I think you should have a global filter to find out current_company and check its validity. current_company would come from subdomain
    #FIXME_AB: also it should be done as current_company.admins.find_by. This way it will ease the method
    @admin = Admin.find_by(id: params[:id])
    #FIXME_AB: redirecting without message?
    redirect_to admins_path if @admin.nil? || @admin.subdomain != request.subdomain
  end

  def redirect_if_company_admin
    #FIXME_AB: simpilify it as "unless current_admin.company_admin?""
    if @admin.role == 'company_admin' && current_admin.role != 'company_admin'
      redirect_to admins_path, alert: 'Cannot Edit Company Admin'
    end
  end

end

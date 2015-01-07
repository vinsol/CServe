class CompaniesController < ApplicationController

  before_action :redirect_to_dashboard, :if => :admin_signed_in?, :only => :new

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      session[:company_id] = @company.id
      redirect_to new_admin_registration_path, notice: 'You have been successfully registered.'
    else
      flash.now[:alert] = @company.errors.full_messages.to_a.to_sentence
      render :new
    end
  end

  private
  def company_params
    params[:company].permit(:name, :subdomain)
  end

  def redirect_to_dashboard
    redirect_to admins_path, alert: 'Already registered'
  end

end

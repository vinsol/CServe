class CompaniesController < ApplicationController

  layout 'company', only: [:new, :create]

  before_action :validate_subdomain
  before_action :authenticate_company!, only: :support_eamil_confirmation

  def new
    @company = Company.new
    @admin = @company.admins.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to root_url, notice: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
    else
      render :new
    end
  end

  def support_eamil_confirmation
    orignal_token = params[:confirmation_token]
    if orignal_token == current_company.confirmation_token
      @company.update(confirmation_token: nil)
      redirect_to sign_in_path, notice: 'Yout Contact email has been confirmed.Now redirect it to our Email'
    else
      redirect_to sign_in_path, alert: 'Confirmation Token Invalid'
    end
  end

  protected

  def company_params
    params[:company].permit(:name, :subdomain, :support_email, admins_attributes: [:name, :email, :password, :password_confirmation])
  end

end

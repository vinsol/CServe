class CompaniesController < ApplicationController

  layout 'company', only: [:new, :create]

  before_action :validate_subdomain

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

  protected

  def company_params
    params[:company].permit(:name, :subdomain, admins_attributes: [:name, :email, :password, :password_confirmation])
  end

end

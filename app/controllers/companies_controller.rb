class CompaniesController < ApplicationController

  def new
    @company = Company.new
    @admin = @company.admins.build
  end

  def create
    @company = Company.new(company_params)
    @admin = @company.admins.build(admin_params)
    if @company.save
      redirect_to root_url, notice: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
    else
      errors = []
      errors = @admin.errors.full_messages if @admin.errors.messages.present?
      @company.errors.full_messages.each do |message|
        errors << 'Company ' + message if message != 'Admins is invalid'
      end
      flash[:alert] = errors.to_sentence
      render :new
    end
  end

  protected

  def company_params
    params[:company].permit(:name, :subdomain)
  end

  def admin_params
    params[:company][:admin].permit(:name, :email, :password, :password_confirmation, :role)
  end
end

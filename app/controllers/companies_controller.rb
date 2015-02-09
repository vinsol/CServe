class CompaniesController < ApplicationController

  layout 'company', only: [:new, :create]

  #FIXME_AB: I should not be able to signup through subdomain url: http://webonrails.lvh.me:3000/sign_up
  def new
    @company = Company.new
    #FIXME_AB: why @admins not @admin
    @admins = @company.admins.build
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
    #FIXME_AB: You should not permit :company_id from the form. I can hack it in html and change password for other company
    params[:company].permit(:name, :subdomain, admins_attributes: [:name, :email, :password, :password_confirmation, :role, :company_id])
  end

end

class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to root_url, notice: 'You have been successfully registered.'
    else
      flash.now[:alert] = @company.errors.full_messages.to_a.to_sentence
      render :new
    end
  end

  private
  def company_params
    params[:company].permit(:name, :subdomain)
  end

end

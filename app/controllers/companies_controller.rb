class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to root_url, notice: 'You have been successfully registered.' }
      else
        format.html do
          flash.now[:alert] = @company.errors.full_messages.to_a.to_sentence
          render :new
        end
      end
    end
  end

  private
  def company_params
    params[:company].permit(:name, :subdomain)
  end

end

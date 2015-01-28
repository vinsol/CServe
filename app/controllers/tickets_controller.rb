class TicketsController < ApplicationController

  layout 'admins', only: [:index, :show, :new]

  before_action :authenticate_admin!, only: :index
  before_action :check_subdomain?, only: :new
  before_action :load_company, only: :create

  def index
    @tickets = Ticket.where(company_id: current_admin.company_id).order('updated_at DESC').page(params[:page])
  end

  def new
    @ticket = Ticket.new
    @ticket.attachments.build
  end

  def create
    @ticket = @company.tickets.build(ticket_params)
    if @ticket.save
      redirect_to new_ticket_path, notice: 'Your request has been successfully submitted. You will recieve a confirmation mail shortly.'
    else
      @ticket.attachments.build
      render :new
    end
  end

  def show
    @ticket =  Ticket.find_by(id: params[:id])
    @comments = Comment.where(ticket_id: @ticket)
    @comment = @ticket.comments.build
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

    def load_company
      @company = Company.find_by(name: request.subdomain)
      redirect_to root_path, alert: 'Company not found.' unless @company
    end

end

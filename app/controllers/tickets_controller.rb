class TicketsController < ApplicationController
  layout 'admins', only: [:index, :show]
  before_action :authenticate_admin!, only: [:index]

  def index
    @tickets = Ticket.where(company_id: current_admin.company_id).order(:updated_at).page(params[:page])
  end

  def create
    @company = Company.where(name: request.subdomain).first
    @ticket = @company.tickets.build(ticket_params)
    if @ticket.save
      redirect_to feedback_path, notice: 'Feedback Successfully Submitted'
    else
      @ticket.attachments.build
      render 'companies/feedback'
    end
  end

  def show
    @ticket =  Ticket.find_by(id: params[:id])
    @comments = @ticket.comments
    @comment = Comment.new
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

end
class TicketsController < ApplicationController

  layout 'user'

  before_action :validate_subdomain
  before_action :load_ticket, only: :show

  def new
    @ticket = current_company.tickets.build
    @ticket.attachments.build
  end

  def create
    @ticket = current_company.tickets.build(ticket_params)
    if @ticket.save
      redirect_to new_ticket_path, notice: 'Your request has been successfully submitted. You will recieve a confirmation mail shortly.'
    else
      @ticket.attachments.build if @ticket.attachments.empty?
      render :new
    end
  end

  def show
    @comments = @ticket.comments
                       .for_user
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

    def load_ticket
      @ticket =  current_company.tickets.find_by(id: params[:id])
      redirect_to tickets_path, alert: 'Ticket not found.' unless @ticket
    end

end

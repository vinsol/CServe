class TicketsController < ApplicationController
  layout 'company', only: [:create]

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      redirect_to feedback_path, notice: 'Feedback Successfully Submitted'
    else
      @ticket.attachments.build
      render 'companies/feedback'
    end
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

end

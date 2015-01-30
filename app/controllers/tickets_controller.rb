class TicketsController < ApplicationController

  layout 'admins', only: [:index, :show, :new, :create]

  before_action :authenticate_admin!, only: :index
  before_action :check_subdomain?, only: :new
  before_action :load_company, only: :create
  before_action :load_ticket, only: [:resolve, :show, :reopen, :close]
  before_action :assign_admin, only: :show

  def index
    if params[:status]
      @tickets = Ticket.unassigned(current_admin.company_id)
                       .order('updated_at DESC')
                       .page(params[:page])
    else
      @tickets = current_admin.tickets
                              .order('updated_at DESC')
                              .page(params[:page])
    end
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
      @ticket.attachments.build if @ticket.attachments.empty?
      render :new
    end
  end

  def show
    @comments = Comment.where(ticket_id: @ticket)
    @comment = @ticket.comments.build
  end

  def resolve
    @ticket.resolve! if @ticket.may_resolve?
    redirect_to ticket_path(@ticket)
  end

  def close
    @ticket.close! if @ticket.may_close?
    redirect_to ticket_path(@ticket)
  end

  def reopen
    @ticket.reopen! if @ticket.may_reopen?
    redirect_to ticket_path(@ticket)
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

    def load_company
      @company = Company.find_by(subdomain: request.subdomain)
      redirect_to root_path, alert: 'Company not found.' unless @company
    end

    def load_ticket
      @ticket =  Ticket.find_by(id: params[:id])
      redirect_to tickets_path, alert: 'Ticket not found.' unless @ticket
    end

    def assign_admin
      if @ticket.admin_id.nil?
        @ticket.assign!
        @ticket.update_column(:admin_id, current_admin.id)
      end
    end

end

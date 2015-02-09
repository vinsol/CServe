class TicketsController < ApplicationController

  #FIXME_AB: We should inherit all admin controllers from a admin base controller and put common code and filters there. like setting layout, authenticate_admin! etc
  layout 'admins', only: [:index, :show, :new, :create]

  before_action :authenticate_admin!, only: :index
  #FIXME_AB: Why this filter needed for new action only?
  before_action :check_subdomain?, only: :new
  before_action :load_company, only: :create
  before_action :load_ticket, only: [:resolve, :show, :reopen, :close, :assign]
  before_action :redirect_if_invalid_transition, only: [:resolve, :reopen, :close]
  before_action :assign_admin, only: :show

  def index
    #FIXME_AB: 1. Use association. current_company.tickets.unassigned etc.
    #FIXME_AB: 2. Avoid repetition by using scoped
    if params[:status]
      @tickets = Ticket.unassigned(current_admin.company_id)
                       .order('updated_at DESC')
                       .page(params[:page])
    else
      @tickets = current_admin.company.tickets
                                      .where.not(state: :new)
                                      .order('updated_at DESC')
                                      .page(params[:page])
    end
  end

  def new
    #FIXME_AB: current_company.tickets.build
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
    #FIXME_AB: Really? 
    @comments = Comment.where(ticket_id: @ticket)
    @comments = @comments.for_user unless current_admin
    @comment = @ticket.comments.build
  end

  %w(reopen resolve close).each do |_method_|
    define_method _method_ do 
      @ticket.public_send("#{ _method_ }!")
      redirect_to ticket_path(@ticket), notice: 'State Successfully Changed'
    end
  end

  def assign
    #FIXME_AB: what if admin id is not present?
    @ticket.update_attribute(:admin_id, ticket_assign_params[:admin_id])
    @ticket.reassign!
    redirect_to tickets_path, notice: 'Ticket Successfully Assigned'
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

    def load_company
      #FIXME_AB: repetition. we should have current_company
      @company = Company.find_by(subdomain: request.subdomain)
      redirect_to root_path, alert: 'Company not found.' unless @company
    end

    def load_ticket
      @ticket =  Ticket.find_by(id: params[:id])
      redirect_to tickets_path, alert: 'Ticket not found.' unless @ticket
    end

    def assign_admin
      if @ticket.admin_id.nil? && admin_signed_in?
        @ticket.update_column(:admin_id, current_admin.id)
        @ticket.assign!
      end
    end

    def ticket_assign_params
      params.require(:ticket).permit(:admin_id)
    end

    def redirect_if_invalid_transition
      unless @ticket.public_send("may_#{ params[:action] }?")
        redirect_to tickets_path, alert: 'Cannot process request'
      end
    end

end

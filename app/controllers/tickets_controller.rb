class TicketsController < BaseController

  layout 'admins', only: [:index, :show, :new, :create]

  skip_before_action :authenticate_admin!, except: :index
  before_action :validate_subdomain, except: :index
  before_action :load_ticket, only: [:resolve, :show, :reopen, :close, :assign, :reassign]
  before_action :redirect_if_invalid_transition, only: [:resolve, :reopen, :close]

  def index
    @tickets = current_company.tickets
    if params[:status] == 'unassigned'
      @tickets = @tickets.unassigned
    else
      @search = @tickets.where(admin_id: current_admin.id)
                        .where.not(state: :unassigned)
                        .search(params[:q])
      @tickets = @search.result                    
    end
    @tickets = @tickets.order('updated_at DESC')
                      .page(params[:page])
  end

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
    @comments = @comments.for_user unless current_admin
  end

  %w(reopen resolve close).each do |_method_|
    define_method _method_ do
      @ticket.public_send("#{ _method_ }!")
      redirect_to ticket_path(@ticket), notice: 'State Successfully Changed'
    end
  end

  %w(assign reassign).each do |_method_|
    define_method _method_ do
      @ticket.update_attribute(:admin_id, ticket_assign_params[:admin_id])
      @ticket.public_send("#{ _method_ }!")
      redirect_to tickets_path, notice: 'Ticket Successfully Assigned'
    end
  end

  private

    def ticket_params
      params.require(:ticket).permit(:email, :description, :subject, attachments_attributes: [:document])
    end

    def load_ticket
      @ticket =  current_company.tickets.find_by(id: params[:id])
      redirect_to tickets_path, alert: 'Ticket not found.' unless @ticket
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

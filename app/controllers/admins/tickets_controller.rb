class Admins::TicketsController < BaseController

  layout 'admins', only: [:index, :show, :new, :create]

  before_action :load_ticket, only: [:resolve, :show, :reopen, :close, :assign, :reassign]
  before_action :set_search_params_if_nil, only: :index
  before_action :redirect_if_invalid_transition, only: [:resolve, :reopen, :close, :assign, :reassign]

  def index
    @tickets = current_company.tickets
    if params[:status] == 'unassigned'
      @tickets = @tickets.unassigned
    else
      @search = @tickets.where.not(state: :unassigned)
                        .search(params[:q])
      @tickets = @search.result                    
    end
    @tickets = @tickets.order('updated_at DESC')
                      .page(params[:page])
  end

  def show
    @comments = @ticket.comments
    @comments = @comments.for_user unless current_admin
  end

  %w(reopen resolve close).each do |_method_|
    define_method _method_ do
      @ticket.public_send("#{ _method_ }!")
      redirect_to admins_ticket_path(@ticket), notice: 'State Successfully Changed'
    end
  end

  %w(assign reassign).each do |_method_|
    define_method _method_ do
      @ticket.update_attribute(:admin_id, ticket_assign_params[:admin_id])
      @ticket.public_send("#{ _method_ }!")
      redirect_to admins_tickets_path, notice: 'Ticket Successfully Assigned'
    end
  end

  private

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

    def set_search_params_if_nil
      unless params[:q]
        params[:q] = {}
        params[:q][:admin_id_eq] = current_admin.id
        params[:q][:state_eq] = ''
      end
    end

end

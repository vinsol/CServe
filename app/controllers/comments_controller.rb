class CommentsController < ApplicationController

  before_action :authenticate_company!
  before_action :load_ticket
  before_action :ensure_correct_company

  def create
    @comment = @ticket.comments.build(comment_params.merge(public: true, commenter_email: @ticket.email))
    if @comment.save
      redirect_to ticket_path(@ticket), notice: 'Successfully commented'
    else
      redirect_to ticket_path(@ticket), alert: 'Enter comment'
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text)
    end

    def load_ticket
      @ticket = Ticket.find_by(id: params[:ticket_id])
      redirect_to root_path, alert: 'Ticket not found.' unless @ticket
    end

    def ensure_correct_company
      redirect_to root_path, alert: 'Incorrect Company' unless current_company.id == @ticket.company_id
    end

end

class CommentsController < ApplicationController

  def create
    @ticket = Ticket.find_by(id: params[:ticket_id])
    @comment = @ticket.comments.build(comment_params)
    @comment.set_commenter_email(current_admin, @ticket)
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

end
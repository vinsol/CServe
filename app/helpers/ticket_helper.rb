module TicketHelper
  def admins
    Admin.where.not(id: @ticket.admin.id).where(active: true)
      .map { |admin| [admin.name.capitalize, admin.id] }
      .unshift([@ticket.admin.name.capitalize, @ticket.admin.id])
  end
end

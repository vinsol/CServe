module TicketHelper
  def admins
    Admin.where.not(id: current_admin.id).where(active: true).map { |admin| [admin.name.capitalize, admin.id] }
  end
end

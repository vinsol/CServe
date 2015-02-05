module TicketHelper
  def admins
    Admin.where.not(id: @ticket.admin.id).where(active: true)
      .map { |admin| [admin.name.capitalize, admin.id] }
      .unshift([@ticket.admin.name.capitalize, @ticket.admin.id])
  end

  def company_admins
    Company.find_by(subdomain: request.subdomain).admins
      .map do |admin|
        admin == current_admin ? ['Me', admin.id] : [admin.name.capitalize, admin.id]
      end
      .unshift(['Select Assignee', ''])
  end
end

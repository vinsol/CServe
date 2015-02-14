module TicketHelper
  def admin_list
    current_company.admins.where(enabled: true)
      .map { |admin| [admin.name.capitalize, admin.id] }
  end

  def company_admins
    current_company.admins
      .map do |admin|
        admin == current_admin ? ['Me', admin.id] : [admin.name.capitalize, admin.id]
      end
      .unshift(['All', ''])
  end

  def add_active(value)
    value ? 'active' : ''
  end

  def set_url(ticket)
    ticket.unassigned? ? assign_ticket_path : reassign_ticket_path
  end
end

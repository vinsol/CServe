class AddColumnsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :admin_id, :integer
    add_column :tickets, :state, :string, default: 'new'
  end
end

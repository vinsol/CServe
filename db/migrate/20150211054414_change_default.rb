class ChangeDefault < ActiveRecord::Migration

  def self.up
    change_column_default(:tickets, :state, 'unassigned')
  end

  def self.down
    change_column_default(:tickets, :state, 'unassigned')
  end

end

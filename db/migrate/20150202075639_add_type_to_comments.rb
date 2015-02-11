class AddTypeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :type, :string, default: 'public'
  end
end

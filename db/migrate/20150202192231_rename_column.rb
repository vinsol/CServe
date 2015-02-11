class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :comments, :type, :kind
  end
end

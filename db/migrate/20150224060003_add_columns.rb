class AddColumns < ActiveRecord::Migration
  def change
    add_column :tickets, :unique_id, :string
    rename_column :companies, :contact_email, :support_email
  end
end

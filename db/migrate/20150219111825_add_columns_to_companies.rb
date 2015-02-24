class AddColumnsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :contact_email, :string
    add_column :companies, :confirmation_token, :string
  end
end

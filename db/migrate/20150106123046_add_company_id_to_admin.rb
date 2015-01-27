class AddCompanyIdToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :company_id, :integer
  end
end

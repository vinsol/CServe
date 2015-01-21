class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :email
      t.string :subject
      t.text :description
      t.integer :company_id

      t.timestamps
    end
  end
end

class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :company_id
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
    add_index :categories, :company_id
  end
end

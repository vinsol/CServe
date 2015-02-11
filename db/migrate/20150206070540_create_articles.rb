class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.integer :admin_id
      t.integer :company_id
      t.string :state

      t.timestamps null: false
    end
  end
end

class CreateArticlesCategories < ActiveRecord::Migration
  def change
    create_table :articles_categories do |t|
      t.integer :article_id
      t.integer :category_id
    end
    add_index :articles_categories, :article_id
    add_index :articles_categories, :category_id
  end
end

class ChangeColumn < ActiveRecord::Migration
  def change

    add_index :tickets, :email
    add_index :tickets, :subject
    add_index :tickets, :company_id
    add_index :tickets, :admin_id

    add_index     :admins, :company_id
    rename_column :admins, :active, :enabled
    add_column    :admins, :company_admin, :boolean, default: false
    remove_column :admins, :role

    add_index :attachments, :ticket_id

    add_index     :comments, :ticket_id
    add_column    :comments, :public, :boolean
    remove_column :comments, :kind

    add_index :articles, :title
    add_index :articles, :description
    add_index :articles, :admin_id
    add_index :articles, :company_id

    add_index :companies, :subdomain, unique: true

  end
end

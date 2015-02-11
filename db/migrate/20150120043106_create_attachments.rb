class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :ticket_id, null: false
      t.string :type
      t.attachment :document

      t.timestamps
    end
  end
end

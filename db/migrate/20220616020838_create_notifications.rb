class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :report, null: false, foreign_key: true
      t.boolean :unread

      t.timestamps
    end
  end
end

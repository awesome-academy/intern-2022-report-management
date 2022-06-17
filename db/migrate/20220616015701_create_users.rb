class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :role, default: 0
      t.string :password_digest
      t.boolean :activated, default: false
      t.string :reset_digest
      t.datetime :reset_send_at
      t.references :division, default: 1, null: false, foreign_key: true

      t.timestamps
    end
  end
end

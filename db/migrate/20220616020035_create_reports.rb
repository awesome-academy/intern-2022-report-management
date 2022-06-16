class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.text :today_plan
      t.text :actual
      t.text :reason_not_complete
      t.text :tomorrow_plan
      t.text :free_comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

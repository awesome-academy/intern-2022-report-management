class ChangeDivisionFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :division_id, from: false, to: true
  end
end

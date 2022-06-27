class RemoveDefaultDivisionFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :division_id, from: 1, to: nil
  end
end

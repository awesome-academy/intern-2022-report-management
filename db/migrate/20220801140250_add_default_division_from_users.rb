class AddDefaultDivisionFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :division_id, from: nil, to: 1
  end
end

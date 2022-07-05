class AddDivisionIdToReports < ActiveRecord::Migration[6.1]
  def change
    add_reference :reports, :division, index: true, foreign_key: true
  end
end

class Report < ApplicationRecord
  UPDATABLE_ATTRS = %i(today_plan actual reason_not_complete
    tomorrow_plan free_comment).freeze

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :today_plan, :actual, :tomorrow_plan,
            presence: true,
            length: {maximum: Settings.report.column.max_length}
  validates :reason_not_complete, :free_comment,
            length: {maximum: Settings.report.column.max_length}
end

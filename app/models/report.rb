class Report < ApplicationRecord
  UPDATABLE_ATTRS = %i(today_plan actual reason_not_complete
    tomorrow_plan free_comment).freeze

  enum status: {waitting: 0, checked: 1}

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :today_plan, :actual, :tomorrow_plan,
            presence: true,
            length: {maximum: Settings.report.column.max_length}
  validates :reason_not_complete, :free_comment,
            length: {maximum: Settings.report.column.max_length}

  scope :recent_reports, ->{order created_at: :desc}
  scope :active_reports, ->{where deleted: false}
  scope :date_created, ->(date){where("date(created_at) = :date", date: date)}
  scope :status, ->(status){where("status = :status", status: status)}
end

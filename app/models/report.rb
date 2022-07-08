class Report < ApplicationRecord
  UPDATABLE_ATTRS = %i(today_plan actual reason_not_complete
    tomorrow_plan free_comment division_id).freeze

  enum status: {waitting: 0, checked: 1}

  belongs_to :user

  belongs_to :division

  has_many :comments, dependent: :destroy

  delegate :name, :email, to: :user, prefix: true

  delegate :name, to: :division, prefix: true

  validates :today_plan, :actual, :tomorrow_plan,
            presence: true,
            length: {maximum: Settings.report.column.max_length}
  validates :reason_not_complete, :free_comment,
            length: {maximum: Settings.report.column.max_length}

  scope :recent, ->{order created_at: :desc}
  scope :active, ->{where deleted: false}
  scope :by_ids, ->(report_ids){where id: report_ids}
  scope :by_users, ->(user_ids){where user_id: user_ids}
  scope :by_status,
        (lambda do |status|
          where("status = ?", status) if status.present?
        end)
  scope :by_created_at,
        (lambda do |date|
          where("date(created_at) = ?", date) if date.present?
        end)
  scope :by_division_id,
        (lambda do |division_id|
          where(division_id: division_id) if division_id.present?
        end)
end

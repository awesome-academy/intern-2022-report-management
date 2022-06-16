class Report < ApplicationRecord
  belongs_to :user
  belongs_to :notification
  has_many :comments, dependent: :destroy
end

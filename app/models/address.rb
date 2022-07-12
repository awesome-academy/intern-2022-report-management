class Address < ApplicationRecord
  belongs_to :user

  validates :city, :country, presence: true

  def detail
    "#{city} #{country}"
  end
end

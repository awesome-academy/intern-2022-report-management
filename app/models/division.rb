class Division < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :reports, dependent: :destroy
end

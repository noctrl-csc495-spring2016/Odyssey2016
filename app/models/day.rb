class Day < ApplicationRecord
  has_many :pickups
  
  validates :date, presence: true
end

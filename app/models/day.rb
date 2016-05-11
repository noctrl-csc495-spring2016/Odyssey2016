class Day < ActiveRecord::Base
  has_many :pickups
  
  validates :date, presence: true
end

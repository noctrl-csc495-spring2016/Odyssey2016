class Pickup < ActiveRecord::Base
  belongs_to :day
  
  validates :donor_first_name,    presence: true
  validates :donor_last_name,     presence: true
  validates :donor_address_line1, presence: true
  validates :donor_city,          presence: true
  validates :donor_zip,           presence: true
  validates :donor_dwelling_type, presence: true
  validates :number_of_items,     presence: true
end

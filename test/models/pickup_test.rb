require 'test_helper'

class PickupTest < ActiveSupport::TestCase
  
  #Create pickup with bare minimum requirements
  def setup
    @pickup = Pickup.new(donor_last_name: "Prucha", donor_phone: "(630) 555-5555", 
    donor_city: "Naperville", donor_address_line1: "555 Drury Ln", 
    donor_zip: "60540", donor_dwelling_type: "Current residence", 
    number_of_items: 2)
  end
  
  test "should be valid" do 
    assert @pickup.valid?
  end
  
  test "donor email validation" do
    @pickup.donor_email = "foo@invalid"
    assert_not @pickup.valid?
  end
  
  #Number of items validation. Must be a number and must be
  #Greater than 0
  test "Number of Items out of range" do
    @pickup.number_of_items = -1
    assert_not @pickup.valid?
  end
  
  #Make sure number of items is a number
  test "Number of Items not a number" do
    @pickup.number_of_items = "AAA"
    assert_not @pickup.valid?
  end
  
  #Make sure number of items is present
  test "number_of_items should be present" do
    @pickup.number_of_items = ""
    assert_not @pickup.valid?
  end
  
  #TESTS FOR MISSING REQUIREMENTS
  test "donor_phone should not be required" do
    @pickup.donor_phone = "  "
    assert @pickup.valid?
  end
  
  test "donor_name should be present" do
    @pickup.donor_last_name = "  "
    assert_not @pickup.valid?
  end
  
  test "donor_address should be present" do
    @pickup.donor_address_line1 = "  "
    assert_not @pickup.valid?
  end
  
  test "donor_city should be present" do
    @pickup.donor_city = "  "
    assert_not @pickup.valid?
  end
  
  test "donor_zip should be present" do
    @pickup.donor_zip = "  "
    assert_not @pickup.valid?
  end
  
end

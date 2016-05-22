require 'test_helper'

class PickupsNewFormTest < ActionDispatch::IntegrationTest
  
setup do 
  @pickup = Pickup.first
end
  
#Test to submit a form with valid pickup information
test "should create new pickup from form" do
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  assert_difference 'Pickup.count', 1 do
  post_via_redirect pickups_path, pickup: { donor_last_name:  'Brown',
                                            donor_phone:  '(630) 555-5555',
                                            donor_address_line1:  '15 Drury Lane',
                                            donor_city: 'Naperville',
                                            donor_dwelling_type: 'Current residence',
                                            donor_zip: '60540',
                                            number_of_items: 2}
  end
  assert_template 'pickups/index'
end  

#Test to submit a form with necessary information missing
test "failed to create new pickup from form because of missing attributes" do
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  assert_difference 'Pickup.count', 0 do
  post_via_redirect pickups_path, pickup: { donor_last_name:  ' ',               #missing requirement
                                            donor_phone:  '(630) 555-5555',
                                            donor_address_line1:  '15 Drury Lane',
                                            donor_city: 'Naperville',
                                            donor_dwelling_type: 'Current residence',
                                            donor_zip: '60540',
                                            number_of_items: 2}
  end
  assert flash.empty? == false    #There should be a flash message
  assert_template 'pickups/new'   #Should re-render 'new'
end

#Test to submit a form with invalid email
test "Failed to accept email submitted in form" do
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  assert_difference 'Pickup.count', 0 do
  post_via_redirect pickups_path, pickup: { donor_last_name:  'Prucha',
                                            donor_phone:  '(630) 555-5555',
                                            donor_address_line1:  '15 Drury Lane',
                                            donor_email: 'foo@invalid',
                                            donor_city: 'Naperville',
                                            donor_dwelling_type: 'Current residence',
                                            donor_zip: '60540',
                                            number_of_items: 2}
  end
  assert flash.empty? == false    #There should be a flash message
  assert_template 'pickups/new'   #Should re-render 'new'
end

test "Make sure schedule, unschedule, and reject do not appear on edit form for entry user" do
  log_in_as(users(:mark))
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  assert_select "input[value=?]",  "Schedule", false
  assert_select "input[value=?]",  "Unschedule", false
  assert_select "input[value=?]",  "Reject", false
end

test "Make sure update, schedule, and reject appear on edit form for at least standard user" do
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  assert_select "input[value=?]",  "Update"
  assert_select "input[value=?]",  "Unschedule"
  assert_select "input[value=?]",  "Reject"
end

test "Make sure schedule button appears for unscheduled pickup" do
  log_in_as(users(:bill))
      @unscheduledPickup = Pickup.create( donor_last_name:  'Prucha',
                                          donor_phone:  '(630) 555-5555',
                                          donor_address_line1:  '15 Drury Lane',
                                          donor_city: 'Naperville',
                                          donor_dwelling_type: 'Current residence',
                                          donor_zip: '60540',
                                          number_of_items: 2)
  get edit_pickup_path(@unscheduledPickup)
  assert_template 'pickups/edit'
  assert_select "input[value=?]",  "Schedule", true
  assert_select "input[value=?]",  "Unschedule", false
end

test "Make sure unschedule button appears for scheduled pickup" do
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  assert_select "input[value=?]",  "Schedule", false
  assert_select "input[value=?]",  "Unschedule", true
end



end

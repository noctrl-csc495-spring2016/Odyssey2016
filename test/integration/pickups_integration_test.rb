require 'test_helper'

class PickupsIntegrationTest < ActionDispatch::IntegrationTest
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
  assert flash.empty? == false    #There should be a flash message with missing attributes
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
  assert flash.empty? == false    #There should be a flash message with invalid email
  assert_template 'pickups/new'   #Should re-render 'new'
end

#BUTTONS APPEARING ON FORM TESTS
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

test "Make sure schedule button appears for unscheduled pickup on edit form" do
  log_in_as(users(:bill))
  @unscheduledPickup = Pickup.create(     donor_last_name:  'Prucha',
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

test "Make sure unschedule button appears for scheduled pickup on edit form" do
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  assert_select "input[value=?]",  "Schedule", false
  assert_select "input[value=?]",  "Unschedule", true
end

test "Should update scheduled pickup" do
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  #puts(@pickup.donor_city)
  patch '/pickups/' + @pickup.id.to_s, update_donor: true, id: @pickup.id, pickup: { 
                                    donor_last_name:  "Prucha",
                                    donor_phone: "(630) 555-5555",
                                    donor_address_line1:  "15 Drury Lane",
                                    donor_city: "Naperville",
                                    donor_email: "markprucha@yahoo.com",
                                    donor_dwelling_type: "Current residence",
                                    donor_zip: "60540",
                                    number_of_items: 2}
  @pickup.reload
  assert_redirected_to '/days/' + @pickup.day_id.to_s
  assert_not flash.empty?
  assert_equal "Prucha", @pickup.donor_last_name
  assert_equal "(630) 555-5555", @pickup.donor_phone
  assert_equal "15 Drury Lane",  @pickup.donor_address_line1
  assert_equal "Naperville", @pickup.donor_city
  assert_equal "markprucha@yahoo.com", @pickup.donor_email
  assert_equal "Current residence", @pickup.donor_dwelling_type
  assert_equal "60540", @pickup.donor_zip
  assert_equal 2, @pickup.number_of_items
end

test "should update unscheduled pickup" do
  log_in_as(users(:bill))
  @pickup.day_id = nil
  @pickup.save
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, update_donor: true, id: @pickup.id, pickup: { 
                                    donor_last_name:  "Prucha",
                                    donor_phone: "(630) 555-5555",
                                    donor_address_line1:  "15 Drury Lane",
                                    donor_city: "Naperville",
                                    donor_email: "markprucha@yahoo.com",
                                    donor_dwelling_type: "Current residence",
                                    donor_zip: "60540",
                                    number_of_items: 2,
                                    day_id: nil}
  

  @pickup.reload
  assert_redirected_to '/pickups'
  assert_not flash.empty?
  assert_equal "Prucha", @pickup.donor_last_name
  assert_equal "(630) 555-5555", @pickup.donor_phone
  assert_equal "15 Drury Lane",  @pickup.donor_address_line1
  assert_equal "Naperville", @pickup.donor_city
  assert_equal "markprucha@yahoo.com", @pickup.donor_email
  assert_equal "Current residence", @pickup.donor_dwelling_type
  assert_equal "60540", @pickup.donor_zip
  assert_equal 2, @pickup.number_of_items
end

test "Should schedule pickup" do
  log_in_as(users(:bill))
  @pickup.day_id = nil
  @pickup.save
  assert_equal nil, @pickup.day_id
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, schedule: true, id: @pickup.id, pickup: { 
                                    day_id: 1}
  @pickup.reload
  assert_redirected_to '/pickups'
  assert_not flash.empty?
 
  assert_equal 1, @pickup.day_id
end

test "Should fail to schedule pickup" do
  log_in_as(users(:bill))
  @pickup.day_id = nil
  @pickup.save
  assert_equal nil, @pickup.day_id
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, schedule: true, id: @pickup.id, pickup: { 
                                    day_id: nil}
  @pickup.reload
  assert_template 'edit'
  assert_not flash.empty?
  assert_equal nil, @pickup.day_id
end

test "Should unschedule pickup" do
  log_in_as(users(:bill))
  assert_equal 1, @pickup.day_id
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, unschedule: true, id: @pickup.id, pickup: { 
                                    day_id: nil}
  @pickup.reload
  assert_redirected_to '/pickups'
  assert_not flash.empty?
 
  assert_equal nil, @pickup.day_id
end

test "Should reject pickup without sending to email preview" do
  log_in_as(users(:bill))
  assert_equal 1, @pickup.day_id
  assert_equal false, @pickup.rejected
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    rejected: true, rejected_reason: "Out of area", send_email: false}
  @pickup.reload
  assert_redirected_to '/pickups'
  assert_not flash.empty?
 
  assert_equal true, @pickup.rejected
end

test "Should not reject pickup because of missing email" do
  log_in_as(users(:bill))
  assert_equal 1, @pickup.day_id
  assert_equal false, @pickup.rejected
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    donor_email: "", rejected: true, rejected_reason: "Out of area", send_email: true}
  @pickup.reload
  assert_not flash.empty?
  assert_template 'edit'
  assert_equal false, @pickup.rejected
end

test "Should reject pickup and send to email preview" do
  log_in_as(users(:bill))
  assert_equal 1, @pickup.day_id
  #assert_equal false, @pickup.rejected
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    donor_email: "markprucha@yahoo.com", 
                                    rejected: true, 
                                    rejected_reason: "Out of area", 
                                    send_email: true}
  @pickup.reload
  assert_equal true, flash.empty?
  assert_template 'reject'
  assert_equal true, @pickup.rejected
  assert_equal "Out of area", @pickup.rejected_reason
end


end

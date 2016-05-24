require 'test_helper'

class PickupsIntegrationTest < ActionDispatch::IntegrationTest
setup do 
  #Set pickup to the pickup in the .yml file.
  @pickup = Pickup.first
end

#FORM INTEGRATION TESTS
#Test to submit a form with valid pickup information
test "should create new pickup from form" do
  #Login and go to form to create a new pickup
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  
  #Check count to make sure pickup is created.
  assert_difference 'Pickup.count', 1 do
  post_via_redirect pickups_path, pickup: { donor_last_name:  'Brown',
                                            donor_phone:  '(630) 555-5555',
                                            donor_address_line1:  '15 Drury Lane',
                                            donor_city: 'Naperville',
                                            donor_dwelling_type: 'Current residence',
                                            donor_zip: '60540',
                                            number_of_items: 2}
  end
  
  #Make sure you are on the index page upon successful submission
  assert_template 'pickups/index'
end  

#Test to submit a form with necessary information missing
test "failed to create new pickup from form because of missing attributes" do
  #Login and go to new pickup page
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  
  #Make sure pickup isn't created by checking the count difference
  #If its 0 then pickup wasn't created.
  assert_difference 'Pickup.count', 0 do
  post_via_redirect pickups_path, pickup: { donor_last_name:  ' ',               #missing requirement
                                            donor_phone:  '(630) 555-5555',
                                            donor_address_line1:  '15 Drury Lane',
                                            donor_city: 'Naperville',
                                            donor_dwelling_type: 'Current residence',
                                            donor_zip: '60540',
                                            number_of_items: 2}
  end
  assert flash.empty? == false    #There should be a flash message with errors
  assert_template 'pickups/new'   #Should be on new page
end

#Test to submit a form with invalid email
#We enter foo@invalid as attribute for donor_email
#This will result in a failure since a .com, .org, etc. is not present.
test "Failed to accept email submitted in form" do
  #Login and go to new pickup page
  log_in_as(users(:bill))
  get new_pickup_path
  assert_template 'pickups/new'
  
  #Fill in form fields and post. Check difference in count to make sure
  #pickup was not created.
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
  assert_template 'pickups/new'   #Should be on new page
end

#Test to update a scheduled pickup via the edit form.
#Since we are updating, and not creating, we use "patch" instead of "post".
test "Should update scheduled pickup" do
  #Log in.
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  
  #When updating a pickup we must patch to pickup/<pickupID>
  #Upon doing so, we enter the update action in the controller.
  #The button pressed in this case should be update_donor button, which is why
  #we set it to true as a parameter in the patch command.
  patch '/pickups/' + @pickup.id.to_s, update_donor: true, id: @pickup.id, pickup: { 
                                    donor_last_name:  "Prucha",
                                    donor_phone: "(630) 555-5555",
                                    donor_address_line1:  "15 Drury Lane",
                                    donor_city: "Naperville",
                                    donor_email: "markprucha@yahoo.com",
                                    donor_dwelling_type: "Current residence",
                                    donor_zip: "60540",
                                    number_of_items: 2}
                                    
  #We must refresh the pickup after update to see if the new fields took.                             
  @pickup.reload
  
  #Since we are updating from schedule page, we want to redirect back to 
  #days/<PickupID> page.
  assert_redirected_to '/days/' + @pickup.day_id.to_s
  
  #Flash message for successful update.
  assert_not flash.empty?
  
  #Check the fields and make sure they are attributes of the updated pickup.
  assert_equal "Prucha", @pickup.donor_last_name
  assert_equal "(630) 555-5555", @pickup.donor_phone
  assert_equal "15 Drury Lane",  @pickup.donor_address_line1
  assert_equal "Naperville", @pickup.donor_city
  assert_equal "markprucha@yahoo.com", @pickup.donor_email
  assert_equal "Current residence", @pickup.donor_dwelling_type
  assert_equal "60540", @pickup.donor_zip
  assert_equal 2, @pickup.number_of_items
end

#Test to update an unscheduled pickup via the edit form.
#The only difference in this test from the test above is the redirect
#To /pickups upon successful update. This is because the edit form was not
#accessed from a schedule page.
test "should update unscheduled pickup" do
  
  #Manually set the day id to nil to make it unscheduled. (Could also perform
  #operations listed in the unschedule test".)
  @pickup.day_id = nil
  @pickup.save
  
  #Login
  log_in_as(users(:bill))
  
  #Go to edit form and patch with edited pickup information
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, update_donor: true, id: @pickup.id, pickup: { 
                                    donor_last_name:  "Prucha",
                                    donor_phone: "(630) 555-5555",
                                    donor_address_line1:  "15 Drury Lane",
                                    donor_city: "Naperville",
                                    donor_email: "markprucha@yahoo.com",
                                    donor_dwelling_type: "Current residence",
                                    donor_zip: "60540",
                                    number_of_items: 2}
  
  #Refresh the pickup to make sure update took.
  @pickup.reload
  
  #If the pickup was scheduled, this would redirect to /days/<PickupID>. Since its
  #Not scheduled, we want to make sure we redirect to /pickups upon update.
  assert_redirected_to '/pickups'
  
  #Flash message for successful pickup update
  assert_not flash.empty?
  
  #Make sure the following fields are now attributes of the updated pickup.
  assert_equal "Prucha", @pickup.donor_last_name
  assert_equal "(630) 555-5555", @pickup.donor_phone
  assert_equal "15 Drury Lane",  @pickup.donor_address_line1
  assert_equal "Naperville", @pickup.donor_city
  assert_equal "markprucha@yahoo.com", @pickup.donor_email
  assert_equal "Current residence", @pickup.donor_dwelling_type
  assert_equal "60540", @pickup.donor_zip
  assert_equal 2, @pickup.number_of_items
end

#Test to schedule a pickup.
test "Should schedule pickup" do
  #Set the pickup to unscheduled.
  @pickup.day_id = nil
  @pickup.save
  
  #Proof that pickup is not scheduled
  assert_equal nil, @pickup.day_id
  
  #Log in
  log_in_as(users(:bill))
  
  #Get edit page for pickup and assign it a day id.
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, schedule: true, id: @pickup.id, pickup: { 
                                    day_id: 1}
                                    
  #Refresh pickup information
  @pickup.reload
  
  #Make sure upon successful schedule, you are redirected to /pickups
  assert_redirected_to '/pickups'
  
  #Flash message that pickup has been scheduled.
  assert_not flash.empty?
 
  #Proof that pickup is scheduled.
  assert_equal 1, @pickup.day_id
end

#Test for a failure to schedule a pickup. This will occur when schedule is pressed
#and schedule spinner does not contain a day.
test "Should fail to schedule pickup" do
  #Set pickup to unscheduled.
  @pickup.day_id = nil
  @pickup.save
  
  #Proof that pickup is unscheduled
  assert_equal nil, @pickup.day_id
  
  #Login and go to edit page. Patch the update with an empty day_id (will occur
  #if schedule spinner is empty when user clicks schedule).
  log_in_as(users(:bill))
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, schedule: true, id: @pickup.id, pickup: { 
                                    day_id: ""}
                                    
  #Refresh pickup with updated attributes
  @pickup.reload
  
  #Make sure we are on the edit page and error flash message is there
  assert_template 'edit'
  assert_not flash.empty?
  
  #Proof that pickup doesn't have a day id (not scheduled).
  assert_equal nil, @pickup.day_id
end

#Test for what happens when unschedule button is pressed.
test "Should unschedule pickup" do
  #Log in.
  log_in_as(users(:bill))
  
  #Proof that pickup is scheduled.
  assert_equal 1, @pickup.day_id
  
  #Go to edit page for that pickup.
  get edit_pickup_path(@pickup)
  
  #Patch it the day_id, clicking the unschedule button. This is why
  #unschedule is set to true.
  patch '/pickups/' + @pickup.id.to_s, unschedule: true, id: @pickup.id, pickup: { 
                                    day_id: nil}
                                    
  #Refresh the pickup with updated information
  @pickup.reload
  
  #Make sure we are redirected to /pickups upon unschedule.
  assert_redirected_to '/pickups'
  
  #Flash message saying pickup was unscheduled.
  assert_not flash.empty?
 
  #Proof that pickup is not scheduled.
  assert_equal nil, @pickup.day_id
end

#Test for when reject is pressed and send email checkbox is not checked.
test "Should reject pickup without sending to email preview" do
  #Log in
  log_in_as(users(:bill))
  
  #Proof that pickup is scheduled with day_id of 1.
  assert_equal 1, @pickup.day_id
  
  #Proof that pickup is not rejected.
  assert_equal false, @pickup.rejected
  
  #Go to edit page and select reject with the checkbox set to false.
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    rejected: true, rejected_reason: "Out of area", send_email: false}
                                    
  #Refresh pickup with updated info.
  @pickup.reload
  
  #Make sure we are sent back to /pickups upon reject without email donor checked..
  assert_redirected_to '/pickups'
  
  #Flash message saying pickup rejected.
  assert_not flash.empty?
 
  #Proof that pickup is rejected.
  assert_equal true, @pickup.rejected
end

#Test to make sure pickup rejection fails when an email is missing
#and the email donor checkbox is checked.
test "Should not reject pickup because of missing email and email donor checked" do
  log_in_as(users(:bill))
  
  #Proof that pickup is not rejected.
  assert_equal 1, @pickup.day_id
  assert_equal false, @pickup.rejected
  
  #Go to edit page for pickup and reject with missing email and email donor checkbox checked.
  get edit_pickup_path(@pickup)
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    donor_email: "", rejected: true, rejected_reason: "Out of area", send_email: true}
                                    
  #Refresh the pickup information.
  @pickup.reload
  
  #Flash errors on edit page.
  assert_not flash.empty?
  
  #Make sure we are on edit page.
  assert_template 'edit'
  
  #Proof that pickup hasn't been rejected.
  assert_equal false, @pickup.rejected
end

#Test to reject a pickup when donor email is present and email donor checkbox
#is checked.
test "Should reject pickup and send to email preview" do
  log_in_as(users(:bill))
  
  #Proof that pickup is not rejected.
  assert_equal false, @pickup.rejected
  
  #Go to edit page for pickup.
  get edit_pickup_path(@pickup)
  
  #Try to reject pickup when email donor checkbox is true, donor email is present
  #and rejected reason is present.
  patch '/pickups/' + @pickup.id.to_s, reject: true, id: @pickup.id, pickup: { 
                                    donor_email: "markprucha@yahoo.com", 
                                    rejected: true, 
                                    rejected_reason: "Out of area", 
                                    send_email: true}
                                    
  #Refresh pickup information.  
  @pickup.reload
  
  #Make sure flash is empty on the email preview page.
  assert_equal true, flash.empty?
  
  #Make sure we are on the email preview page.
  assert_template 'reject'
  
  #Proof that pickup is rejected.
  assert_equal true, @pickup.rejected
  assert_equal "Out of area", @pickup.rejected_reason
end


#BUTTONS APPEARING ON FORM TESTS

#Schedule, unschedule, and reject buttons should not appear on edit form when user
#is entry level.
test "Make sure schedule, unschedule, and reject do not appear on edit form for entry user" do
  
  #Log in as an entry level user.
  log_in_as(users(:mark))
  
  #Go to edit page for pickup.
  get edit_pickup_path(@pickup)
  
  #Proof that we are on edit page.
  assert_template 'pickups/edit'
  
  #Proof that proper buttons are missing.
  assert_select "input[value=?]",  "Schedule", false
  assert_select "input[value=?]",  "Unschedule", false
  assert_select "input[value=?]",  "Reject", false
  assert_select "input[value=?]",  "Update", true
end

#All form buttons should appear on edit form for at least a standard user
test "Make sure update, schedule, and reject appear on edit form for at least standard user" do
  #Log in as standard.
  log_in_as(users(:bill))
  
  #Get edit form for pickup
  get edit_pickup_path(@pickup)
  
  #Proof that we are on edit page.
  assert_template 'pickups/edit'
  
  #Proof that all buttons are there.
  assert_select "input[value=?]",  "Update"
  assert_select "input[value=?]",  "Unschedule"
  assert_select "input[value=?]",  "Reject"
  assert_select "input[value=?]",  "Update"
end

#Schedule button should appear for unscheduled pickups.
test "Make sure schedule button appears for unscheduled pickup on edit form" do
  log_in_as(users(:bill))
  
  #Set pickup to unscheduled.
  @pickup.day_id = nil
  @pickup.save
  
  #Proof that pickup is unscheduled.
  assert_equal nil, @pickup.day_id
  
  #Go to edit page.
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  
  #Make sure schedule button appears and unschedule doesn't.
  assert_select "input[value=?]",  "Schedule", true
  assert_select "input[value=?]",  "Unschedule", false
end

#Unschedule button should appear for scheduled pickups.
test "Make sure unschedule button appears for scheduled pickup on edit form" do
  log_in_as(users(:bill))
  
  #Go to edit page for pickup.
  get edit_pickup_path(@pickup)
  assert_template 'pickups/edit'
  
  #Make sure unschedule button appears and schedule doesn't.
  assert_select "input[value=?]",  "Schedule", false
  assert_select "input[value=?]",  "Unschedule", true
end



end

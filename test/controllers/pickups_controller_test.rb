require 'test_helper'

class PickupsControllerTest < ActionController::TestCase
 #Set pickup to the first pickup in the .yml
setup do 
  @pickup = Pickup.first
end

#Test the various conroller functions and templates associated with them
test "should get pickups" do
  log_in_as(users(:bill))
  get :index
  assert_response :success
  assert_template 'pickups/index'
end

test "should get new pickup" do
  log_in_as(users(:bill))
  get :new
  assert_response :success
  assert_template 'pickups/new'
  assert_select "a[href=?]", pickups_path
end

test "should get edit" do
  log_in_as(users(:bill))
  get :edit, id: @pickup
  assert_response :success
  assert_template 'pickups/edit'
  assert_select "a[href=?]", pickups_path
end

test "should get reject" do 
  log_in_as(users(:bill))
  @rejectedPickup = Pickup.create( donor_last_name:  'Prucha',
                                          donor_phone:  '(630) 555-5555',
                                          donor_address_line1:  '15 Drury Lane',
                                          donor_city: 'Naperville',
                                          donor_email: 'markprucha@yahoo.com',
                                          donor_dwelling_type: 'Current residence',
                                          donor_zip: '60540',
                                          number_of_items: 2,
                                          send_email: true,
                                          rejected: true,
                                          rejected_reason: 'Out of area')
  get :reject, id: @pickup
  assert_response :success
  assert_template 'pickups/reject'
  assert_select "a[href=?]", pickups_path
  end

test "should delete pickup" do
    assert_difference('Pickup.count', -1) do
      @pickup.delete
    end
end

end

require 'test_helper'

class PickupsControllerTest < ActionController::TestCase
   #Set pickup to the first pickup in the .yml
  setup do 
    @pickup = Pickup.first
  end


  test "should get index" do
    log_in_as(users(:bill))
    
    get :index
    assert_response :success
    assert_not_nil assigns(:pickups)
  end

  test "should get new" do
    log_in_as(users(:bill))
    
    get :new
    assert_response :success
  end

# NOTE FROM KEVIN M: If you want to uncomment these, refer to https://hashrocket.com/blog/posts/how-to-upgrade-to-rails-5 and ctrl + f for "so if you had this in you tests" (nice grammar, I know) for how to make them work 
#  test "should create pickup" do
#    log_in_as(users(:bill))
#    
#    assert_difference('Pickup.count') do
#      post :create, pickup: { day_id: @pickup.day_id, donor_address_line1: @pickup.donor_address_line1, donor_address_line2: @pickup.donor_address_line2, donor_city: @pickup.donor_city, donor_dwelling_type: @pickup.donor_dwelling_type, donor_email: @pickup.donor_email, donor_first_name: @pickup.donor_first_name, donor_last_name: @pickup.donor_last_name, donor_notes: @pickup.donor_notes, donor_phone: @pickup.donor_phone, donor_spouse_name: @pickup.donor_spouse_name, donor_title: @pickup.donor_title, donor_zip: @pickup.donor_zip, item_notes: @pickup.item_notes, number_of_items: @pickup.number_of_items, rejected: @pickup.rejected, rejected_reason: @pickup.rejected_reason }
#    end
#
#    assert_redirected_to pickup_path(assigns(:pickup))
#  end

#  test "should show pickup" do
#    log_in_as(users(:bill))
#    
#    get :show, id: @pickup
#    assert_response :success
#  end

  test "should get edit" do
  log_in_as(users(:bill))
  get :edit, params: { id: @pickup }
  assert_response :success
  assert_template 'pickups/edit' #should be on edit
  assert_select "a[href=?]", pickups_path #There should be a link to index
end

#  test "should update pickup" do
#    log_in_as(users(:bill))
#    
#    patch :update, id: @pickup, pickup: { day_id: @pickup.day_id, donor_address_line1: @pickup.donor_address_line1, donor_address_line2: @pickup.donor_address_line2, donor_city: @pickup.donor_city, donor_dwelling_type: @pickup.donor_dwelling_type, donor_email: @pickup.donor_email, donor_first_name: @pickup.donor_first_name, donor_last_name: @pickup.donor_last_name, donor_notes: @pickup.donor_notes, donor_phone: @pickup.donor_phone, donor_spouse_name: @pickup.donor_spouse_name, donor_title: @pickup.donor_title, donor_zip: @pickup.donor_zip, item_notes: @pickup.item_notes, number_of_items: @pickup.number_of_items, rejected: @pickup.rejected, rejected_reason: @pickup.rejected_reason }
#    assert_redirected_to pickup_path(assigns(:pickup))
#  end

  #Test the various controller functions and templates associated with them
  test "should get pickups" do
    log_in_as(users(:bill))
    get :index
    assert_response :success
    assert_template 'pickups/index' #Should be on index
  end

  test "should get new pickup" do
    log_in_as(users(:bill))
    get :new
    assert_response :success
    assert_template 'pickups/new' #Should be on new
    assert_select "a[href=?]", pickups_path #There should be link to index
  end



#Test for email preview page.
test "should get reject" do 
  log_in_as(users(:bill))
  
  #Create rejected pickup
  @rejectedPickup = Pickup.create(  donor_last_name:  'Prucha',
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
  get :reject, params: { id: @pickup }
  assert_response :success
  assert_template 'pickups/reject' #Make sure we are on rejected page.
  assert_select "a[href=?]", pickups_path #Make sure there is a link to index.
  end
end

require 'test_helper'

class PickupsControllerTest < ActionController::TestCase
  setup do
    @pickup = pickups(:one)
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

  test "should create pickup" do
    log_in_as(users(:bill))
    
    assert_difference('Pickup.count') do
      post :create, pickup: { day_id: @pickup.day_id, donor_address_line1: @pickup.donor_address_line1, donor_address_line2: @pickup.donor_address_line2, donor_city: @pickup.donor_city, donor_dwelling_type: @pickup.donor_dwelling_type, donor_email: @pickup.donor_email, donor_first_name: @pickup.donor_first_name, donor_last_name: @pickup.donor_last_name, donor_notes: @pickup.donor_notes, donor_phone: @pickup.donor_phone, donor_spouse_name: @pickup.donor_spouse_name, donor_title: @pickup.donor_title, donor_zip: @pickup.donor_zip, item_notes: @pickup.item_notes, number_of_items: @pickup.number_of_items, rejected: @pickup.rejected, rejected_reason: @pickup.rejected_reason }
    end

    assert_redirected_to pickup_path(assigns(:pickup))
  end

  test "should show pickup" do
    log_in_as(users(:bill))
    
    get :show, id: @pickup
    assert_response :success
  end

  test "should get edit" do
    log_in_as(users(:bill))
    
    get :edit, id: @pickup
    assert_response :success
  end

  test "should update pickup" do
    log_in_as(users(:bill))
    
    patch :update, id: @pickup, pickup: { day_id: @pickup.day_id, donor_address_line1: @pickup.donor_address_line1, donor_address_line2: @pickup.donor_address_line2, donor_city: @pickup.donor_city, donor_dwelling_type: @pickup.donor_dwelling_type, donor_email: @pickup.donor_email, donor_first_name: @pickup.donor_first_name, donor_last_name: @pickup.donor_last_name, donor_notes: @pickup.donor_notes, donor_phone: @pickup.donor_phone, donor_spouse_name: @pickup.donor_spouse_name, donor_title: @pickup.donor_title, donor_zip: @pickup.donor_zip, item_notes: @pickup.item_notes, number_of_items: @pickup.number_of_items, rejected: @pickup.rejected, rejected_reason: @pickup.rejected_reason }
    assert_redirected_to pickup_path(assigns(:pickup))
  end

  test "should destroy pickup" do
    assert_difference('Pickup.count', -1) do
      delete :destroy, id: @pickup
    end

    assert_redirected_to pickups_path
  end
end

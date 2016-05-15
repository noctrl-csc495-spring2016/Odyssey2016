require 'test_helper'

class DaysControllerTest < ActionController::TestCase
  setup do
    @day = days(:one)
    @day_in_past = days(:two)
  end

  test "should get index" do
    log_in_as(users(:bill))
    
    get :index
    assert_response :success
    assert_not_nil assigns(:days)
  end

  test "should get new" do
    log_in_as(users(:bill))
    
    get :new
    assert_response :success
  end

  test "should create day and not create duplicate" do
    log_in_as(users(:bill))
    
    assert_difference('Day.count') do
      post :create, { month:"June" , day:12 , year: 2016}
    end
    
    assert_redirected_to days_path
    
    assert_no_difference('Day.count') do
      post :create, { month:"June" , day:12 , year: 2016}
    end

    assert_redirected_to days_new_url
  end

  test "should show day" do
    log_in_as(users(:bill))
    
    get :show, id: @day
    assert_response :success
  end

  test "should destroy day" do
    log_in_as(users(:bill))
    
    assert_difference('Day.count', -1) do
      delete :destroy, id: @day
    end

    assert_redirected_to days_path
  end
  
  test "cannot create day in past" do
    log_in_as(users(:bill))
    
    assert_no_difference('Day.count') do
      post :create, { month:"June" , day:23 , year: 1994}
    end

    assert_redirected_to days_new_url
  end
  
  test "cannot delete day in past" do
    log_in_as(users(:bill))
    
    assert_no_difference('Day.count') do
      delete :destroy, id: @day_in_past
    end

    assert_redirected_to days_path
  end
  
  test "cannot delete day with pickups and button shouldnt show" do
    log_in_as(users(:bill))
    
    @pickup = Pickup.create(  day_id:                       @day.id,
                              donor_first_name:             "Anthony",
                              donor_last_name:              "Rizzo",
                              donor_address_line1:          "1060 W Addison St",
                              donor_address_line2:          "Suite 101",
                              donor_city:                   "Chicago",
                              donor_zip:                    "60613",
                              donor_dwelling_type:          "Historic Ball Park",
                              donor_phone:                  "(773) 404-2827",
                              donor_email:                  "rizzo@cubs.com",
                              number_of_items:               1,
                              item_notes:                   "Autographed baseball" )
    
    get :show, id: @day
    assert_select "div[id=delete-button]", false
    
    assert_no_difference('Day.count') do
      delete :destroy, id: @day
    end

    assert_redirected_to days_path
  end
  
  test "cannot add invalid days" do
    log_in_as(users(:bill))
    
    assert_no_difference('Day.count') do
      post :create, { month:"February" , day:31 , year: 2017}
    end

    assert_redirected_to days_new_url
  end
end
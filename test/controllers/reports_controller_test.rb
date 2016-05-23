require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  test "should get donor report page" do
    log_in_as(users(:bill))
    get :donor
    assert_response :success
    assert_select "title", "Odyssey | Donor Report"
  end
  
  test "should get truck report page" do
    log_in_as(users(:bill))
    get :truck
    assert_response :success
    assert_select "title", "Odyssey | Truck Report"
  end
  
  test "should get main reports page" do
    log_in_as(users(:bill))
    get :index
    assert_response :success
    assert_select "title", "Odyssey | Reports"
  end
end

require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  test "should get donors report page" do
    log_in_as(users(:bill))
    get :donor
    assert_response :success
    assert_select "title", "Odyssey | Donors"
  end
  
  test "should get MapQuest report page" do
    log_in_as(users(:bill))
    get :mapquest
    assert_response :success
    assert_select "title", "Odyssey | MapQuest"
  end
  
  test "should get Rejected report page" do
    log_in_as(users(:bill))
    get :rejected
    assert_response :success
    assert_select "title", "Odyssey | Rejected"
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

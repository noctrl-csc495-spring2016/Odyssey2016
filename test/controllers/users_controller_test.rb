require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:bill)
    @other = users(:charlie)
    @corey = users(:corey)
    @gerardo = users(:gerardo)
  end

  test "should get index" do
    log_in_as(users(:bill))

    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
  
  test "should not get index" do
    log_in_as(users(:corey))

    get :index
    assert_redirected_to pickups_path
    assert_not flash.empty?
  end

  test "should get new" do
    log_in_as(users(:bill))
    get :new
    assert_response :success
  end
  
  test "should not get new" do
    log_in_as(users(:corey))
    get :new
    assert_redirected_to pickups_path
    assert_not flash.empty?
  end

  test "should create user" do
    log_in_as(users(:bill))
    assert_difference('User.count') do
      post :create, user: { email: "cjmiller@noctrl.edu", password: "charlie", password_confirmation: "charlie", permission_level: 2, username: "charlie miller" }
    end

    assert_redirected_to users_index_path
    assert_not flash.empty?
  end
  
  test "should not create user - permission level" do
    log_in_as(users(:corey))
    assert_no_difference('User.count') do
      post :create, user: { email: "cjmiller@noctrl.edu", password: "charlie", password_confirmation: "charlie", permission_level: 2, username: "charlie miller" }
    end

    assert_redirected_to pickups_path
    assert_not flash.empty?
  end
  
  test "should not create user - bad input" do
    log_in_as(users(:bill))
    assert_no_difference('User.count') do
      post :create, user: { email: "cjmiller@noctrl.edu", password: "cha", password_confirmation: "char", permission_level: 2, username: "charlie miller" }
    end

    assert_template "new"
    assert_not flash.empty?
  end

  test "should get edit" do
    log_in_as(users(:corey))
    get :edit, id: @corey
    assert_response :success
  end
  
  test "should not get edit" do
    log_in_as(users(:corey))

    get :show, id: 100
    assert_redirected_to pickups_path
    assert_not flash.empty?
  end
  
  test "should get show" do
    log_in_as(users(:bill))

    get :show, id: @user
    assert_response :success
  end
  
  test "should not get show" do
    log_in_as(users(:bill))

    get :show, id: 100
    assert_redirected_to pickups_path
    assert_not flash.empty?
  end

  test "should update user" do
    log_in_as(users(:bill))
    get :show, id: @user
    assert_response :success

    #pass = @user.password_digest
    patch :update, id: @user, user: { confirm_password: "password", 
                                      password: "password", 
                                      password_confirmation: "password", 
                                      permission_level: @user.permission_level }
                                      
    assert_redirected_to user_path(assigns(:user))
    assert_not flash.empty?

    log_out_as(users(:bill))
    assert_not is_logged_in?
    
    #try as entry user
    log_in_as(users(:corey))
    
    patch :update, id: @corey, user: { password: "passwor", 
                                       password_confirmation: "passwor" }
    assert_redirected_to user_path(assigns(:user))
    assert_not flash.empty?
    
        
    log_out_as(users(:corey))
    assert_not is_logged_in?
    
    #try as superadmin
    log_in_as(users(:gerardo))
    assert is_logged_in?
    put :update, id: @gerardo, user: { confirm_password: "", 
                                         password: "", 
                                         password_confirmation: "passwor", 
                                         permission_level: @gerardo.permission_level }
    
    assert_redirected_to user_path(assigns(:user))
  end
  
  test "should not update user" do
    log_in_as(users(:corey))

    #entry update someone else
    patch :update, id: @user, user: { email: @user.email, password_digest: @user.password_digest, permission_level: @user.permission_level, username: @user.username }
    assert_redirected_to pickups_path
    assert_not flash.empty?
    
    #entry update self with bad input
    patch :update, id: @corey, user: { password: "p", password_confirmation: "password" }
    assert_redirected_to action: "edit"
    assert_not flash.empty?
  end

  test "should destroy user" do
    log_in_as(users(:bill))

    assert_difference('User.count', -1) do
      delete :destroy, id: @other
    end

    assert_redirected_to users_path
        assert_not flash.empty?

  end
  
  test "should not destroy user" do
    log_in_as(users(:bill))

    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end
    
    assert_redirected_to action: "show"
    assert_not flash.empty?
  end
  
  test "should not show superadmin" do
    #try as admin
    log_in_as(users(:bill))

    get :show, id: @gerardo
    assert_redirected_to pickups_path
    assert_not flash.empty?
    
    log_out_as(users(:bill))
    assert_not is_logged_in?
    
    #try as entry user
    log_in_as(users(:corey))
    get :show, id: @gerardo
    assert_redirected_to pickups_path
    assert_not flash.empty?
  end
  
  test "should show superadmin" do
    log_in_as(users(:gerardo))

    get :show, id: @gerardo
    assert_response :success
  end
  
end

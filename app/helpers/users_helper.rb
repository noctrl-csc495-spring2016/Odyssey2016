module UsersHelper
    
  def is_entry?
    current_user && current_user.permission_level == 0
  end
    
  def is_standard?
    current_user && current_user.permission_level == 1
  end
  
  def is_admin?
    current_user && current_user.permission_level == 2
  end
  
  def is_super?
    current_user && current_user.super_admin == true
  end
  
  def user_exists?
    User.find_by_id(params[:id])
  end
  
  def user_exists
    if !user_exists?
      flash[:danger] = "User does not exist"
      redirect_to pickups_path
    end
  end
  
end

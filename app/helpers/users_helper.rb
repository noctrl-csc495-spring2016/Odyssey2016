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
  
end

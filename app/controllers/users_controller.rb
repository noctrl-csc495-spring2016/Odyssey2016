class UsersController < ApplicationController
  before_action :logged_in
  before_action :user_exists, except: [:index, :new, :create, :prune]
  before_action :is_admin, except: [:update, :edit]
  before_action :is_super, only: [:prune]
  
  #Diplays all users, each user in a row
  def index
    #display superadmin only if superadmin is logged in
    if !is_super? 
     @users = User.all.where("super_admin != ?", true).order("UPPER(username)")
    else
     @users = User.all.order("UPPER(username)")
    end
  end

  #Called when an admin clicks on a user in the table on the users index page.
  #Displays the user's info and allows admin to change their password and/or
  #permission level.
  def show
    @user = User.find(params[:id])
    
    #tell user superadmin does not exist to hide his superduper secret existence
    if !is_super? && @user.super_admin == true
      flash[:danger] = "User does not exist"
      redirect_to pickups_path
    end
  end

  def new
    @user = User.new
  end

    
  #Called when a user selects "Settings".  If the user is admin, they are
  #redirected to 'show'.
  def edit
    @user = User.find(params[:id])
    if @user.permission_level == 2
      redirect_to action: "show"
    end
  end

  #Called when the admin wants to create a new user
  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "Successfully created " + @user.username
      redirect_to action: "index"
    else
      flash.now[:danger] = "One or more entries was invalid.  Please check your information and try again."
      render 'new'
    end
  end


  #The Update method has 5 cases
  #super admins updating an account
  #Admins updating themselves (admins cannot delete themselves)
  #admins updating other accounts (cannot update superadmin)
  #Entry or standard accounts updating themselves
  #Entry or standard updating someone they do not have permission to update
  
  #Admins can delete other accounts, update passwords and permission levels
  #
  def update
    @user = User.find(params[:id])
    
    if is_super? 
      
      #confirm password then update users info
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "The user " + @user.username + " has been updated."
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to pickups_path
      end
      
    #admin edits other user  
    elsif is_admin? && current_user.username != @user.username
      #confirm password then update users info
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "The user " + @user.username + " has been updated."
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
      
    #admin edits self
    elsif is_admin? && current_user.username == @user.username
    
      #confirm password then update users info
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "Your account has been updated."
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
    
    #user edits self
    elsif current_user.username == @user.username
    
      if(@user.update_attributes(user_params))
        flash[:success] = "Your account has been updated."
        redirect_to action: "edit"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "edit"
      end
      
    #user edits other
    else
      flash[:danger] = "You do not have permission to update that user"
      redirect_to pickups_path
      
    end

    
  end
  
  # Iterates through the Pickup DB and removes entries > 6 months old.
  def prune
    count = 0
    Pickup.all.each do |pickup|
      if pickup.updated_at < 6.months.ago
        pickup.destroy
        count += 1
      end
    end
    flash[:success] = pluralize(count, 'pickup was', 'pickups were') + " removed."
    redirect_to users_index_path
  end

  #destroy is an action that admins can use to delete accounts
  #but not themselves
  def destroy
    
    #check user is not deleting self
    if User.find(params[:id]).username != current_user.username
      if User.find(params[:id]).super_admin == true
        flash[:danger] = "User does not exist"
        redirect_to pickups_path
      else  
        name = User.find(params[:id]).username
        User.find(params[:id]).destroy
        flash[:success] = "Successfully deleted " + name
        redirect_to users_url
      end
      
    else
      
      flash[:danger] = "You cannot delete yourself"
      redirect_to action: "show"
      
    end
  end

  #password and password confirmation are BCrypt defaults.  They must be called
  #by these names for BCrypt to recognize them
  #They are not part of the user model
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def super_params
      params.require(:user).permit(:password, :password_confirmation,  :permission_level)
    end
    
    def new_user_params
      params.require(:user).permit(:username, :email, :permission_level, :password, :password_confirmation)
    end
    
    def admin_params
      params.require(:user).permit(:permission_level, :password, :password_confirmation)
    end
    
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end
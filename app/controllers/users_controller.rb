class UsersController < ApplicationController
  before_action :logged_in
  before_action :user_exists, except: [:index, :new, :create]
  before_action :is_admin, except: [:update, :edit]
  
  def index
    #display superadmin only if superadmin is logged in
    if !is_super? 
     @users = User.all.where("super_admin != ?", true).order("UPPER(username)")
    else
     @users = User.all.order("UPPER(username)")
    end
  end

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

    
  #admins have a different profile page so we redirect them to 'show'
  def edit
    @user = User.find(params[:id])
    if @user.permission_level == 2
      redirect_to action: "show"
    end
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "Successfully created " + @user.username
      redirect_to action: "index"
    else
      flash.now[:danger] = "Input Invalid"
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    
    #if is_super? && @user.super_admin == true
      
    if is_super? 
      
      #confirm password then update users info
      if current_user.authenticate(params[:current_password]) && @user.update_attributes(admin_params)
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
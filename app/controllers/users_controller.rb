class UsersController < ApplicationController
  before_action :logged_in
  before_action :user_exists
  before_action :is_admin, except: [:update, :edit]
  
  def index
    if current_user.super_admin == false
     @users = User.all.where("super_admin != ?", true).order("UPPER(username)")
    else
     @users = User.all.order("UPPER(username)")
    end
  end

  def show
    if(User.find_by_id(params[:id]))
      @user = User.find(params[:id])
      if !current_user.super_admin == true && @user.super_admin == true
        flash[:danger] = "You do not have permission to access this page"
        redirect_to pickups_path
      end
    else
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    if @user.permission_level == 2
      redirect_to action: "show"
    end
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "Successfully created account"
      redirect_to action: "index"
    else
      flash.now[:danger] = "Input Invalid"
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    
    #is super admin
    if is_super?
      
    #admin edits other user  
    elsif current_user.permission_level == 2 && current_user.username != @user.username
    
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "You totally updated your account mang"
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
      
    #admin edits self
    elsif current_user.permission_level == 2 && current_user.username == @user.username
    
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(user_params)
        flash[:success] = "Successfully updated account dawg"
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
      
    
    #user edits self
    elsif current_user.username == @user.username
    
      if(@user.update_attributes(user_params))
        flash[:success] = "You totally updated your account mang"
        redirect_to action: "edit"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "edit"
      end
      
    end

    
  end

  def destroy
    if User.find(params[:id]).username != current_user.username
      
      User.find(params[:id]).destroy
      flash[:success] = "Successfully deleted account"
      redirect_to users_url
      
    else
      
      flash[:danger] = "You cannot delete yourself"
      redirect_to action: "show"
      
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def super_params
      params.require(:user).permit(:email, :password_digest, :username, :permission_level, :super_admin)
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
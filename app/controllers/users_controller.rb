class UsersController < ApplicationController
  before_action :logged_in
  before_action :is_admin, except: [:update, :edit]
  def index
     @users = User.all.order("UPPER(username)")
  end

  def show
      @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(admin_params)
    if @user.save
      flash[:success] = "Successfully updated account"
      redirect_to action: "index"
    else
      flash.now[:bad_input] = "Input Invalid"
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    
    #user edit
    if(current_user.username == @user.username && params[:user][:permission_level] == nil)
      if @user.update_attributes(user_params)
        redirect_to action: pickups_path
      else 
        redirect_to action: "edit"
      end
    elsif current_user.super_admin == true
      #do nothing
      
      #admin edit
    elsif(current_user.permission_level == 2)
      if @user.update_attributes(admin_params)
        redirect_to action: "index"
      else
        redirect_to  action: "show"
    
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Successfully deleted account"
    redirect_to users_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def super_params
      params.require(:user).permit(:email, :password_digest, :username, :permission_level, :super_admin)
    end
    
    def admin_params
      params.require(:user).permit(:username, :email, :permission_level, :password, :password_confirmation)
    end
    
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end

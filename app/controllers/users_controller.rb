class UsersController < ApplicationController
  before_action :logged_in
  before_action :is_admin, except: [:update, :edit]
  def index
    @users = User.all
  end

  def show
    
  end

  def new
    @user = User.new
  end

  def edit
    
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password_digest, :username, :permission_level, :super_admin)
    end
end

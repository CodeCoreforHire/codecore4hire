class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :index]
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_user_profile_path(@user), notice: "Logged In!"
    else
      render :new
    end
  end

  def show
  end

  def index
    if params[:hire?]
      @page = params[:page].to_i
      @users = User.where(for_hire: true).order(created_at: :desc).page(@page).per(10)
    else
      @page = params[:page].to_i
      @users = User.order(created_at: :desc).page(@page).per(10)
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update user_params
      redirect_to root_path
    end
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :for_hire, :profile_picture)
  end

  def find_user
    @user = User.find(session[:user_id])
  end
end

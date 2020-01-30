class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :require_same_user, only: %i[edit create update]

  def index
    @users = User.paginate(page: params[:page], per_page: 2)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to alpha blog #{@user.username}"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def update
    if(@user.update(user_params))
      flash[:success] = 'Account updated successfully.'
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    return unless current_user != @user

    flash[:danger] = 'You can only update your profile'
    redirect_to root_path
  end
end

class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create, new, show)
  before_action :correct_user, only: %i(edit, update)
  before_action :admin_user, only: :destroy

  def index
  @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "success"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "danger"
    redirect_to signup_path
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user.destroy
      flash[:success] = t ".users.destroy.success"
    else
      flash[:danger] = t ".users.destroy.fail"
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def admin_user
    redirect_to(root_url) unless current_user.admin?
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t "plslogin"
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to root_url unless current_user?(@user)  
    end
end

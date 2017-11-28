class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      create_success
    else
      create_error
    end
  end

  def create_error
    flash[:danger] = t ".inval_login" # Not quite right!
    render :new
  end

  def create_success
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == Settings.remember_me.default_check ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message  = t "activation.sessions.not"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

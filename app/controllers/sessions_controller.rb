class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      cr_suc
    else
      flasherr
    end
  end

  def flasherr
    flash[:danger] = t ".inval_login" # Not quite right!
    render :new
  end

  def cr_suc
    log_in @user
    params[:session][:remember_me] == Settings.remember_me.default_check ? remember(@user) : forget(@user)
    redirect_to @user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

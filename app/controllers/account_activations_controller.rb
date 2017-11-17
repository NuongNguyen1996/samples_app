class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? or user.authenticated? :activation, params[:id]
      user.activate
      log_in user
      flash[:success] = t "activation.controller.success"
      redirect_to user
    else
      flash[:danger] = t "activation.controller.fail"
      redirect_to root_url
    end
  end
end

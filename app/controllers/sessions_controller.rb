class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new
    redirect_root
  end

  def create
    if @user&.authenticate params[:session][:password]
      flash[:success] = t ".login_success_notify"
      log_in @user
      redirect_to root_path
    else
      flash.now[:danger] = t ".ivalid_account_notify"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  private

  def find_user
    @user = User.find_by email: params[:session][:email].downcase
    redirect_to root_path unless @user
  end
end

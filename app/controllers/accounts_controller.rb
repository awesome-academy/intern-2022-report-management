class AccountsController < ApplicationController
  before_action :require_login
  before_action :find_user, only: %i(index edit update)

  def index; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to root_path
    else
      flash[:danger] = t ".update_faild"
      redirect_to edit_account_path current_user
    end
  end

  private

  def user_params
    params.permit User::UPDATABLE_ATTRS
  end

  def find_user
    @user = User.find_by id: current_user.id
    redirect_to root_path unless @user
  end
end

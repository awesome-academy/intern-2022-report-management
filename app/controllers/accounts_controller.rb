class AccountsController < ApplicationController
  before_action :require_login

  def index
    @user = User.find_by id: current_user.id
    redirect_to root_path unless @user
  end

  def edit; end
end

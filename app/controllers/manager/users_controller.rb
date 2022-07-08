class Manager::UsersController < ApplicationController
  before_action :require_login, ->{check_role? :manager}
  before_action :find_user, only: %i(show destroy)

  def index
    @members = if params[:name]
                 User.by_name(params[:name])
               else
                 User.member
               end
    @pagy, @members = pagy(@members,
                           items: Settings.paginate.items.item_per_page)
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to manager_users_path
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".find_user_error"
    redirect_to manager_users_path
  end
end

class Manager::UsersController < ApplicationController
  before_action :require_login, ->{check_role? :manager}
  before_action :find_user, only: %i(show destroy edit update)

  def index
    @members = if params[:name]
                 User.by_name(params[:name]).includes(:division, :addresses)
               else
                 User.member.includes(:division, :addresses)
               end
    @pagy, @members = pagy(@members,
                           items: Settings.paginate.items.item_per_page)
  end

  def new
    @user = User.member.new
  end

  def create
    @user = User.member.new user_params

    if @user.save
      flash[:info] = t ".create_success_notify"
      redirect_to manager_users_path
    else
      flash.now[:danger] = t ".create_failed_notify"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".message_success"
      redirect_to manager_users_path
    else
      flash[:danger] = t ".message_fail"
      render :edit
    end
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

  def user_params
    params.require(:user).permit User::UPDATABLE_ATTRS
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".find_user_error"
    redirect_to manager_users_path
  end
end

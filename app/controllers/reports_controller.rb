class ReportsController < ApplicationController
  before_action :check_if_user_login

  def show; end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build report_params

    if @report.save
      flash[:info] = t ".create_success_notify"
      redirect_to report_path(current_user)
    else
      flash.now[:danger] = t ".create_failed_notify"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::UPDATABLE_ATTRS
  end
end

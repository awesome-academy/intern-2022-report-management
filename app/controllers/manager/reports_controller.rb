class Manager::ReportsController < ApplicationController
  before_action :require_login
  before_action :paginate_reports, only: %i(index update)
  before_action :find_report, only: :show
  before_action{check_role? :manager}
  skip_before_action :verify_authenticity_token

  def index; end

  def update
    Report.by_ids(params[:report_ids])
          .each(&:checked!)
    respond_to do |format|
      format.html{redirect_to manager_reports_path}
      format.js
    end
  end

  def show
    @user = @report.user
    @comments = Comment.by_report_id(params[:id])
                       .order_by_created_at
                       .includes(:user)
  end

  private

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:danger] = t ".find_report_error"
    redirect_to reports_path
  end

  def paginate_reports
    filter_report
    @pagy, @reports = pagy(@reports, items: Settings.report.items.item_per_page)
  end

  def filter_report
    @reports = Report.by_users(user_in_division)
                     .active
                     .by_division_id(params[:division_id])
                     .by_created_at(params[:date]&.first)
                     .by_status(params[:status])
                     .recent
                     .includes(:user, :division)
  end

  def user_in_division
    User.by_name(params[:name])
  end
end

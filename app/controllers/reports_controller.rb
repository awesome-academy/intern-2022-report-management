class ReportsController < ApplicationController
  before_action :check_if_user_login
  before_action :find_report, except: %i(new create index)
  before_action :paginate_reports, only: :index

  def index; end

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

  def paginate_reports
    @reports = current_user.reports
                           .active_reports
                           .recent_reports
    filter_report
    @all_reports = @reports
    @pagy, @reports = pagy(@reports, items: Settings.report.items.item_per_page)
  end

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:danger] = t ".find_report_error"
    redirect_to reports_path
  end

  def filter_report
    return unless params[:report] && params[:status]

    @reports = @reports.date_created params[:report][:created] if
      params[:report][:created].present?
    @reports = @reports.status params[:status] if params[:status].present?
  end
end

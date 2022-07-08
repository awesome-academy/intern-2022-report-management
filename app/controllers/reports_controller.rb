class ReportsController < ApplicationController
  before_action :require_login
  before_action :find_report, except: %i(new create index)
  before_action{check_role? :member}

  def index
    @reports = current_user.reports.active.recent
    if params[:filter]
      @reports = @reports.by_status(params[:filter][:status])
                         .by_created_at(params[:filter][:created_at])
    end
    @pagy, @reports = paginate_reports(@reports)
  end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build report_params

    if @report.save
      flash[:info] = t ".create_success_notify"
      redirect_to reports_path
    else
      flash.now[:danger] = t ".create_failed_notify"
      render :new
    end
  end

  def edit; end

  def update
    if @report.update report_params
      flash[:success] = t ".edit_report_success"
      redirect_to reports_path
    else
      flash[:danger] = t ".edit_report_faild"
      redirect_to edit_report_path params[:id]
    end
  end

  def show
    @user = @report.user
    @comments = Comment.by_report_id(params[:id])
                       .order_by_created_at
                       .includes(user: :avatar_attachment)
  end

  def destroy
    if @report.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to reports_url
  end

  private

  def report_params
    params.require(:report).permit Report::UPDATABLE_ATTRS
  end

  def paginate_reports reports
    pagy(reports, items: Settings.paginate.items.item_per_page)
  end

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:danger] = t ".find_report_error"
    redirect_to reports_path
  end
end

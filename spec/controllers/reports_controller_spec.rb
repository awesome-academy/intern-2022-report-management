require "rails_helper"

RSpec.describe ReportsController, type: :controller do
  let(:division) {create :division}
  let!(:current_user){create :user}
  let!(:reports){create_list :report, Settings.rspec.factory_reports_size, user_id: current_user.id, division_id: division.id}
  let!(:comments){create_list :comment, Settings.rspec.factory_comments_size, report_id: reports[0].id}
  let!(:params) {attributes_for :report}

  context "When user does not log in" do
    describe "GET #index" do
      before {get :index, params: {locale: "en"}}

      it { expect(response).to redirect_to new_user_session_path }
    end

    describe "GET #new" do
      before {get :new, params: {locale: "en"}}

      it { expect(response).to redirect_to new_user_session_path }
    end

    describe "GET #edit" do
      before {get :edit, params: {id: reports[0].id, locale: "en"}}

      it { expect(response).to redirect_to new_user_session_path }
    end

    describe "GET #show" do
      before {get :show, params: {id: reports[0].id, locale: "en"}}

      it { expect(response).to redirect_to new_user_session_path }
    end
  end

  context "When user logged in" do
    before {log_in current_user}

    describe "GET #index" do
      context "when do not have any params" do
        before {get :index}

        it { expect(assigns :reports).to eq(reports.reverse.slice(0, Settings.paginate.items.item_per_page)) }
      end

      context "when params page is not nil" do
        before {get :index, params: {page: 2}}

        it { expect(assigns :reports).to eq(reports.reverse.slice(10, 20)) }
      end

      context "when params status is waitting" do
        before {get :index, params: {status: "waitting", filter: {"status"=>"waitting", "created_at"=>Date.current}}}

        it { expect(assigns :reports).to eq(Report.by_status(:status).recent.slice(0, Settings.paginate.items.item_per_page)) }
      end

      context "when all params is given" do
        before {get :index, params: {status: "waitting", page: 2, items: 10}}

        it { expect(assigns :reports).to eq(reports.reverse.slice(10, 20)) }
      end
    end

    describe "GET #show" do
      context "when invalid report_id" do
        before {get :show, params: {id: 1000}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render danger flash" do
          expect(flash[:danger]).to eq I18n.t("reports.find_report_error")
        end
      end

      context "when valid report_id" do
        before {get :show, params: {id: reports[0].id}}

        it "assign @report" do
          expect(assigns :report).to eq reports[0]
        end

        it "assign @user" do
          expect(assigns :user).to eq current_user
        end

        it "assign @comments" do
          expect(assigns :comments).to eq comments.reverse
        end
      end
    end

    describe "GET #new" do
      before {get :new}

      it "should render a danger flash" do
        expect(flash[:danger]).to eq I18n.t("reports.error_create_path")
      end

      it "should redirect to reports_path" do
        expect(response).to redirect_to reports_path
      end
    end

    describe "POST #create" do
      context "when all params is given" do
        before {post :create, params: {report: params}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render a info flash" do
          expect(flash[:info]).to eq I18n.t("reports.create_success_notify")
        end

        it "should have size plus 1" do
          expect{
            post :create, params: {report: params}
          }.to change(Report, :count).by(1)
        end
      end

      context "when params is invalid" do
        before {post :create, params: {report: {today_plan: ""}}}

        it "should render a danger flash" do
          expect(flash.now[:danger]).to eq I18n.t("reports.create_failed_notify")
        end
      end
    end

    describe "PUT #update" do
      context "when report_id is invalid" do
        before {put :update, params: {id: 1000}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render danger flash" do
          expect(flash[:danger]).to eq I18n.t("reports.find_report_error")
        end
      end

      context "when report_id is valid" do
        before {put :update, params: {id: reports[0].id, report: params}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render success flash" do
          expect(flash[:success]).to eq I18n.t("reports.edit_report_success")
        end
      end
    end

    describe "GET #edit" do
      context "when report_id is invalid" do
        before {get :edit, params: {id: 1000}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render danger flash" do
          expect(flash[:danger]).to eq I18n.t("reports.find_report_error")
        end
      end

      context "when report_id is valid" do
        before {get :edit, params: {id: reports[0].id}}

        it "should redirect to reports_path" do
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do
      context "when report_id is invalid" do
        before {delete :destroy, params: {id: 1000}}

        it "should redirect to reports_path" do
          expect(response).to redirect_to reports_path
        end

        it "should render danger flash" do
          expect(flash[:danger]).to eq I18n.t("reports.find_report_error")
        end
      end

      context "when report_id is valid" do
        it "should be deleted" do
          expect{
            delete :destroy, params: {id: reports[0].id}
          }.to change(Report.active, :count).by(-1)
        end
      end

      context "when delete fail" do
        let(:report){build_stubbed(:report)}

        before do
          allow(Report).to receive(:find_by).and_return(report)
          allow(report).to receive(:destroy).and_return(false)
        end

        it "should flash danger not destroy" do
          delete :destroy, params: {id: report.id}
          expect(flash[:danger]).to eq I18n.t("reports.delete_fail")
        end
      end
    end
  end
end

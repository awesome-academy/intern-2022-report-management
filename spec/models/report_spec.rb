require "rails_helper"

RSpec.describe Report, type: :model do
  describe "Enums" do
    it { is_expected.to define_enum_for(:status).with([:waitting, :checked]) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:division) }
  end

  describe "Validations" do
    context "when all fields given" do
      let(:division) {FactoryBot.create :division}
      let(:user) {FactoryBot.create :user}
      let!(:report) {FactoryBot.create :report, user_id: user.id, division_id: division.id}

      it { expect(report.valid?).to eq true }
    end

    context "when all fields missing" do
      let(:report) {FactoryBot.build :report, today_plan: "", actual: "", tomorrow_plan: ""}

      it { expect(report.valid?).to eq false }
    end

    context "when today_plan missing" do
      let(:report_fail) {FactoryBot.build :report, today_plan: ""}

      it { expect(report_fail.valid?).to eq false }
    end

    context "when actual missing" do
      let(:report_fail) {FactoryBot.build :report, actual: ""}

      it { expect(report_fail.valid?).to eq false }
    end

    context "when tomorrow_plan missing" do
      let(:report_fail) {FactoryBot.build :report, tomorrow_plan: ""}

      it { expect(report_fail.valid?).to eq false }
    end
  end

  describe "Scopes" do
    let(:division) {FactoryBot.create :division}
    let(:user) {FactoryBot.create :user}
    let!(:report1) {FactoryBot.create(:report, status: Settings.reports.status.waitting, deleted: true, division_id: division.id)}
    let!(:report2) {FactoryBot.create(:report, status: Settings.reports.status.checked, deleted: false, division_id: division.id)}
    let!(:report3) {FactoryBot.create(:report, status: Settings.reports.status.waitting, deleted: false, division_id: division.id)}
    let!(:report4) {FactoryBot.create(:report, status: Settings.reports.status.waitting, deleted: false, division_id: division.id)}

    describe ".recent" do
      it { expect(Report.recent).to eq([report4, report3, report2, report1]) }
    end

    describe ".active" do
      it { expect(Report.active.size).to eq(3) }
    end

    describe ".by_ids" do
      it { expect(Report.by_ids(2)).to eq(Report.where(id: 2)) }
    end

    describe ".by_users" do
      it { expect(Report.by_users(1)).to eq(Report.where(user_id: 1)) }
    end

    describe ".by_status" do
      context "when status is waitting" do
        it { expect(Report.by_status(:waitting)).to eq([report1, report3, report4]) }
      end

      context "when status is nil" do
        it { expect(Report.by_status(nil)).to eq([report1, report2, report3, report4]) }
      end
    end

    describe ".by_created_at" do
      context "when order by nil" do
        it { expect(Report.by_created_at(nil)).to eq ([report1, report2, report3, report4]) }
      end
    end

    describe ".by_division_id" do
      context "when by division id" do
        it { expect(Report.by_division_id(1)).to eq(Report.where(division_id: 1)) }
      end

      context "when order by nil" do
        it { expect(Report.by_division_id(nil)).to eq [report1, report2, report3, report4] }
      end
    end
  end
end

require "rails_helper"

RSpec.describe StatisticReportsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  let!(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, status: 1, is_manager: 1
  end
  before do
    sign_in user
  end

  describe "GET #index" do
    context "with valid attributes" do
      it "create new statistic report" do
        xhr :get, :index, params: {id: organization.id}
        expect(response).to be_ok
      end

      it "create fail params" do
        xhr :get, :index
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new statistic report" do
        expect do
          post :create, params: {statistic_report:
            attributes_for(:statistic_report, club_id: club.id), date: {year: 2017}, quarter: 3}
        end.to change(StatisticReport, :count).by 1
        expect(flash[:success]).to be_present
      end

      it "create fail with invalid report" do
        expect do
          post :create, params: {statistic_report: {club_id: club.id, style: 2},
            date: {year: 2017}, quarter: 3}
        end.to change(ClubRequest, :count).by 0
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    let(:statistic_report) do
      create :statistic_report, club: club, user: user
    end
    context "with valid status" do
      it "update success with approve params" do
        post :update, xhr: true, params: {organization_slug: organization.slug,
          id: statistic_report.id, status: 1}
        expect(flash[:success]).to be_present
        expect(response).to be_ok
      end

      it "update success with reject params" do
        post :update, xhr: true, params: {statistic_report: {reason_reject: "abcd"},
          organization_slug: organization.slug, id: statistic_report.id, status: 3}
        expect(flash[:success]).to be_present
        expect(response).to be_ok
      end
    end
  end
end

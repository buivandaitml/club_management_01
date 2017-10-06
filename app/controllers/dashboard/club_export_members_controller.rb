class Dashboard::ClubExportMembersController < BaseDashboardController
  before_action :load_club, only: :index
  def index
    @manager = @club.user_clubs.manager.newest
    @members = @club.user_clubs.are_member.newest
    respond_to do |format|
      format.html
      format.xlsx {
      response.headers["Content-Disposition"] = "filename='#{t("list_member")}: #{@club.name}.xlsx'"
      }
    end
  end

  def create
  end

  private
  def load_club
    @club = Club.find_by id: params[:id]
    unless @club
      flash[:danger] = t "club_manager.cant_fount"
      redirect_to dashboard_path
    end
  end
end

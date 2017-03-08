class ClubManager::ClubsController < BaseClubManagerController
  before_action :load_club
  before_action :manager_club

  def show
    @event = Event.new
    @members = @club.user_clubs.newest
    @albums = @club.albums.newest.page(params[:page]).per Settings.per_page_album
    @new_album = Album.new
    @events = @club.events.newest.page(params[:page]).per(Settings.event_page)
  end

  def update
    if @club.update_attributes club_params
      create_acivity @club, Settings.update, @club, current_user
      flash[:success] = t "club_manager.club.success_update"
    else
      flash_error @club
    end
    redirect_to :back
  end

  private
  def club_params
    params.require(:club).permit :name, :description, :logo, :image,
      :notification
  end

  def load_club
    @club = Club.find_by id: params[:id]
    unless @club
      flash[:danger] = t "club_manager.cant_fount"
      redirect_to club_manager_path
    end
  end

  def manager_club
    correct_manager = manager_of_club(current_user).find_by club_id: params[:id]
    unless correct_manager
      flash[:danger] = t "not_correct_manager"
      redirect_to club_manager_path
    end
  end
end

class MailToUserJoinClubJob < ApplicationJob
  queue_as :email

  def perform user, club
    @user = user
    @club = club
    ClubMailer.mail_to_user_join_club(@user, @club).deliver_later
  end
end
#end


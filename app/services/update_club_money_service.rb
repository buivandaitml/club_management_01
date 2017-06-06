class UpdateClubMoneyService
  def initialize event, club, event_params
    @event= event
    @club = club
    @event_params = event_params
  end

  def update_event
    @event.update_attributes! @event_params
  end

  def update_money
    if @event.event_category == Settings.spend && @event.status?
      @club.money -= @event.expense
    elsif @event.event_category == Settings.consum && @event.status?
      @club.money += @event.expense
    end
    @club.save
  end
end

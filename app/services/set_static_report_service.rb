class SetStaticReportService
  def initialize club, category, params
    @club = club
    @category = category
    @params = params
  end

  def load_events
    if @params[:style].to_i == StatisticReport.styles[:monthly]
      if @params[:month].present?
        @club.events.by_event(@category).by_months(@params[:month]).by_years(@params[:date_year])
      else
        @club.events.by_event(@category).by_months(Date.current.month).by_years(@params[:date_year])
      end
    else
      if @params[:quarter].present?
        quarter = SetQuarterReport.new @params[:quarter]
        @club.events.by_event(@category).by_months(quarter.quarter_report)
          .by_years(@params[:date_year])
      else
        @club.events.by_event(@category).by_months(Settings.quarter_1).by_years(@params[:date_year])
      end
    end
  end
end

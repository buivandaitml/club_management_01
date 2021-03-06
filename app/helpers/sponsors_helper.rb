module SponsorsHelper
  def check_experience_detail? experience
    experience[:event].blank? && experience[:time_and_place].blank? &&
      experience[:member].blank? && experience[:communication].blank?
  end

  def status_show sponsor
    if sponsor.rejected?
      link_to club_sponsor_path(@club.id, sponsor.id, status: Sponsor.statuses[:rejected]),
        remote: true, title: t("sponsors.reason_reject") do
        content_tag(:i, t("#{sponsor.status}"), class: "fa fa-eye")
      end
    else
      t "#{sponsor.status}"
    end
  end
end

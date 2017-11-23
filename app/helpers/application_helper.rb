module ApplicationHelper
  def devise_error_messages!
    resource.errors.full_messages.map{|msg| content_tag(:li, msg)}.join
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def index_continue object, index, per_page
    (object.to_i - 1) * per_page.to_i + index + 1
  end

  def flash_error object
    flash[:danger] = object.errors.full_messages
  end

  def manager_of_club user
    @user_clubs = user.user_clubs.manager
  end

  def image_holder album
    album.images.first.url
  end

  def status_user_club user, club
    user_club = user.user_clubs.find_by club_id: club.id
    user_club.present? ? user_club.joined? : nil
  end

  def count_request variable
    variable.club.user_clubs.unactive.count
  end

  def sort_suggest array_club
    h = Hash.new(0)
    array_club.each{|v| h.store(v, h[v] + 1)}
    h = Hash[h.sort_by{|_, v| -v}]
    h.map(&:flatten)
  end

  def club_suggest_user_tag
    clubs = []
    sort_suggest(current_user.tags_clubs).each do |club, _s|
      clubs << club unless current_user.user_clubs.of_club(club)
    end
    clubs
  end

  def active_class link_path
    current_page?(link_path) ? "active" : ""
  end

  def format_date date
    date.strftime(Settings.date_format)
  end

  def correctmanager organization
    is_manager = current_user.user_organizations.load_user_organization(organization.id).are_admin
  end

  def url_approve_user_organization id, status
      if status == :joined
        link_to t("accept"), user_request_organization_path(id: id, status: status),
          method: :put, remote: true, data: {confirm: t("answer_active")}
      else
        link_to t("reject"), user_request_organization_path(id: id, status: status),
          method: :put, remote: true, data: {confirm: t("answer_reject")}
      end
  end

  def url_approve_club_organization object
    link_to object[:name], club_request_organization_path(id: object[:id],
      status: object[:status], organization: object[:organization_id]),
      method: :put, class: "btn btn-sm btn-#{object[:button]}", data: {confirm: object[:confirm]}
  end
end

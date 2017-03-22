class Manager::StaticPagesController < ApplicationController
  layout "manager_layout"

  before_action :user_signed_in
  before_action :admin_verify

  def index
    @organizations = current_user.user_organizations.are_admin
  end

  private
  def admin_verify
    @admin = current_user.user_organizations.are_admin
    unless @admin.any?
      flash[:danger] = t "not_authorities_to_access"
      redirect_to root_path
    end
  end
end

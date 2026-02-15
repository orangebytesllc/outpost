class SettingsController < ApplicationController
  before_action :require_admin

  def show
    @account = Current.user.account
    @users = @account.users.order(:created_at)
  end

  def regenerate_invite_token
    Current.user.account.regenerate_invite_token!
    redirect_to settings_path, notice: "Invite link regenerated."
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless Current.user.admin?
  end
end

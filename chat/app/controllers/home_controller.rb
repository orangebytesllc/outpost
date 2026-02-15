class HomeController < ApplicationController
  allow_unauthenticated_access only: :index
  before_action :redirect_based_on_state, only: :index

  def index
    # Only reached if authenticated and setup complete
  end

  private

  def redirect_based_on_state
    unless Account.setup?
      redirect_to new_setup_path
    else
      redirect_to new_session_path unless authenticated?
    end
  end
end

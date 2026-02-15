class ProfilesController < ApplicationController
  def show
  end

  def update
    if Current.user.update(user_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
end

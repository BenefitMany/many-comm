class Api::ProfileController < ApplicationController
  def show
    respond_with_object_or_message_status(current_user.user, ProfileSerializer, root: 'profile')
  end

  def update
    current_user.user.update_attributes(profile_params)
    respond_with_object_or_message_status(current_user.user, ApiSuccessSerializer, root: 'profile')
  end

  def profile_params
    params.require(:profile).permit(
      :firstName,
      :lastName,
      :newEmail,
      :timeZone,
      :avatar,
      :removeAvatar,
      :password,
      :passwordConfirmation
    ).to_unsafe_h.to_snake_keys
  end
end

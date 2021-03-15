class Api::ForgotPasswordController < ApplicationController
  skip_before_action :authenticate

  def create
    if password_reset_params[:email].present? && User.where(email: password_reset_params[:email]).exists?
      user = User.find_by_email(password_reset_params[:email])
      UserForgotPasswordJob.perform_later(user.id)
    end
    render json: { success: true }
  end

  def update
    if password_reset_params[:token].present? && User.where(perishable_token: password_reset_params[:token]).exists?
      user = User.find_by_perishable_token(password_reset_params[:token])
      user.password = password_reset_params[:password]
      user.password_confirmation = password_reset_params[:password_confirmation]
      if user.save
        UserUpdatedPasswordJob.perform_later(user.id)
        render json: { success: true }
      else
        not_acceptable(user)
      end
    else
      record_not_found('Invalid Token')
    end
  end

  private

  def password_reset_params
    params.to_unsafe_h.to_snake_keys.symbolize_keys
  end
end

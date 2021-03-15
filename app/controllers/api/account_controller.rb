class Api::AccountController < ApplicationController
  skip_before_action :authenticate, raise: false
  before_action :user

  def activate
    @user.update(activated_at: Time.now)
    respond_with_object_or_message_status(@user)
  end

  def verify
    @user.update(email: @user.new_email)
    @user.update(new_email: nil)
    respond_with_object_or_message_status(@user)
  end

  private

  def user
    @user = User.find_by_perishable_token(params[:perishable_token])
    record_not_found('Token not found') if @user.nil?
  end
end

class UserForgotPasswordJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    SendgridManager.password_reset_request(user)
    true
  end
end

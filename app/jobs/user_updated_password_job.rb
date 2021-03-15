class UserUpdatedPasswordJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    SendgridManager.password_updated_notification(user)
    true
  end
end

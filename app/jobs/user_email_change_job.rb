class UserEmailChangeJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    SendgridManager.user_new_email_verification(user)
    true
  end
end

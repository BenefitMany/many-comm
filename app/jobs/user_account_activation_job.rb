class UserAccountActivationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    SendgridManager.user_account_activation(user)
    true
  end
end

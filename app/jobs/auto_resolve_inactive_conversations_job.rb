class AutoResolveInactiveConversationsJob < ApplicationJob
  queue_as :default

  def perform
    CronJob::AutoResolveInactiveConversations.process
    true
  end
end

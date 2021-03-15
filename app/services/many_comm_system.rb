class ManyCommSystem
  def self.auto_resolve_inactive_conversations
    AutoResolveInactiveConversationsJob.perform_later
  end
end

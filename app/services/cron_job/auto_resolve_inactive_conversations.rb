module CronJob
  class AutoResolveInactiveConversations
    def self.process
      obj = new
      obj.run
    end

    def initialize
      @conversation_stamp = Time.now - 4.hours
    end

    def run
      conversation_query.each do |conversation|
        resolve_conversation(conversation)
      end
      true
    end

    private

    def conversation_last_messaged_at
      'SELECT MAX(created_at) FROM messages WHERE conversation_id = conversations.id'
    end

    def conversation_query
      Conversation.where(closed_at: nil).where("(#{conversation_last_messaged_at}) < ?", @conversation_stamp)
    end

    def resolve_conversation(conversation)
      conversation.update_column(:closed_at, Time.now)
      ConversationPurgeJob.set(wait: 5.minutes).perform_later(conversation.id)

      payload = {
        resolved_conversation: {
          identifier: conversation.identifier,
          mobile: conversation.visitor.from_number.present?,
          created_at: conversation.created_at,
          closed_at: conversation.closed_at
        }
      }

      ActionCable.server.broadcast "user_#{conversation.user.identifier}_channel", payload.to_camelback_keys
    end
  end
end

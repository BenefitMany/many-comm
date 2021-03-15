class ConversationPurgeJob < ApplicationJob
  queue_as :default

  def perform(conversation_id)
    conversation = Conversation.where(id: conversation_id).first

    # Conversation was already deleted
    return false if conversation.nil?

    # Conversation was marked unresolved
    return false if conversation.closed_at.nil?

    # It has not been 5 minutes yet, so the conversation was probably marked
    # unresolved, and resolved at another time.  Therefore, let the next ConversationPurgeJob close
    # close it out.
    return false if conversation.closed_at + 5.minutes > Time.now.utc

    payload = {
      remove_conversation: {
        identifier: conversation.identifier
      }
    }

    ActionCable.server.broadcast "user_#{conversation.user.identifier}_channel", payload.to_camelback_keys

    conversation.visitor.destroy
  end
end

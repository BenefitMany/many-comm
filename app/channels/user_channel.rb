class UserChannel < ApplicationCable::Channel
  def subscribed
    return if current_user.nil?

    stream_from "user_#{current_user.user.identifier}_channel"
  end

  def unsubscribed
    return if current_user.nil?

    ConversationAssignmentManager.reassign_operator_conversations(current_user.user)
    # Any cleanup needed when channel is unsubscribed
    # stop_all_streams
  end

  def speak(data)
    info = data.to_snake_keys.symbolize_keys
    case data['method']
    when 'conversation_list' then conversation_list
    when 'message_list' then message_list(info[:conversation_identifier])
    when 'new_message' then new_message(info[:conversation_identifier], info[:message])
    when 'resolve_conversation' then resolve_conversation(info[:conversation_identifier])
    when 'unresolve_conversation' then unresolve_conversation(info[:conversation_identifier])
    end
  end

  private

  # def send_message(data)
  #   opts = {
  #     conversation_identifier: data['conversationIdentifier'],
  #     message: data['message']
  #   }
  #   message = ConversationManager.process_from_operator(opts)
  #   payload = {
  #     message: {
  #       conversation_identifier: message.conversation.identifier,
  #       message: message.message,
  #       message_from: message.messageable_type,
  #       created_at: message.created_at
  #     }
  #   }
  #   # TODO: make else with line below
  #   ActionCable.server.broadcast "user_#{current_user.user_id}_channel", payload.to_camelback_keys
  # end

  def conversation_list
    payload = { conversations: user_conversations }
    ActionCable.server.broadcast "user_#{current_user.user.identifier}_channel", payload.to_camelback_keys
  end

  def find_current_user_conversation_by_identifier(conversation_identifier)
    Conversation.where(user_id: current_user.user_id).where(identifier: conversation_identifier).first
  end

  def message_list(conversation_identifier)
    conversation = find_current_user_conversation_by_identifier(conversation_identifier)
    return if conversation.nil?

    payload = {
      message_list: {
        conversation: {
          name: conversation.visitor.fake_name,
          identifier: conversation.identifier,
          mobile: conversation.visitor.from_number.present?,
          chat_window_status: conversation.visitor.chat_window_status,
          created_at: conversation.created_at,
          closed_at: conversation.closed_at
        },
        messages: conversation.messages.collect do |message|
          {
            message: message.message,
            message_from: message.messageable_type,
            name: message.messageable.name,
            created_at: message.created_at
          }
        end
      }
    }
    ActionCable.server.broadcast "user_#{current_user.user.identifier}_channel", payload.to_camelback_keys
  end

  def new_message(conversation_identifier, message)
    opts = {
      conversation_identifier: conversation_identifier,
      message: message
    }
    ConversationManager.process_from_operator(opts)
  end

  def resolve_conversation(conversation_identifier)
    conversation = find_current_user_conversation_by_identifier(conversation_identifier)
    return if conversation.nil?

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

    ActionCable.server.broadcast "user_#{current_user.user.identifier}_channel", payload.to_camelback_keys
  end

  def unresolve_conversation(conversation_identifier)
    conversation = find_current_user_conversation_by_identifier(conversation_identifier)
    return if conversation.nil?

    conversation.update_column(:closed_at, nil)

    payload = {
      unresolved_conversation: {
        identifier: conversation.identifier,
        mobile: conversation.visitor.from_number.present?,
        created_at: conversation.created_at,
        closed_at: conversation.closed_at
      }
    }

    ActionCable.server.broadcast "user_#{current_user.user.identifier}_channel", payload.to_camelback_keys
  end

  def user_conversations
    Conversation.where(user_id: current_user.user_id).order(created_at: :desc).collect do |conversation|
      {
        name: conversation.visitor.fake_name,
        identifier: conversation.identifier,
        mobile: conversation.visitor.from_number.present?,
        created_at: conversation.created_at,
        closed_at: conversation.closed_at
      }
    end
  end
end

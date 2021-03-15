class VisitorChannel < ApplicationCable::Channel
  def subscribed
    return if params[:conversation].nil?

    stream_from "visitor_#{params[:conversation]}_channel"

    ConversationManager.visitor_init_chat(conversation_identifier: params[:conversation])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # stop_all_streams
  end

  def speak(data)
    info = data.to_snake_keys.symbolize_keys
    case data['method']
    when 'new_message' then new_message(params[:conversation], info[:message])
    when 'closed_chat_window' then closed_chat_window(params[:conversation])
    when 'minimized_chat_window' then minimized_chat_window(params[:conversation])
    when 'open_chat_window' then open_chat_window(params[:conversation])
    end
  end

  private

  def closed_chat_window(conversation_identifier)
    VisitorChatWindowManager.closed_chat_window(conversation_identifier)
  end

  def minimized_chat_window(conversation_identifier)
    VisitorChatWindowManager.minimized_chat_window(conversation_identifier)
  end

  def new_message(conversation_identifier, message)
    opts = {
      conversation_identifier: conversation_identifier,
      from_identifier: conversation_identifier,
      message: message
    }
    ConversationManager.process_from_visitor(opts)
  end

  def open_chat_window(conversation_identifier)
    VisitorChatWindowManager.restored_chat_window(conversation_identifier)
  end
end

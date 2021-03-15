class VisitorChatWindowManager
  def self.closed_chat_window(conversation_identifier)
    obj = new(:closed, conversation_identifier)
    obj.run
  end

  def self.minimized_chat_window(conversation_identifier)
    obj = new(:minimized, conversation_identifier)
    obj.run
  end

  def self.open_chat_window(conversation_identifier)
    obj = new(:open, conversation_identifier)
    obj.run
  end

  def initialize(window_action, conversation_identifier)
    @window_action = window_action
    @conversation_identifier = conversation_identifier

    @conversation = nil
  end

  def run
    load_conversation
    return false if @conversation.nil?

    update_visitor_window_status
    notify_operator
    true
  end

  private

  def load_conversation
    @conversation = Conversation.find_by_identifier(@conversation_identifier)
  end

  def notify_operator; end

  def update_visitor_window_status
    @conversation.visitor.update_column(:chat_window_status, @window_action)
  end
end

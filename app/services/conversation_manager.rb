class ConversationManager
  def self.visitor_init_chat(data)
    obj = new(:visitor, data)
    obj.send_chat_autoresponder_intro
  end

  def self.process_from_visitor(data)
    obj = new(:visitor, data)
    obj.run
  end

  def self.process_from_operator(data)
    obj = new(:operator, data)
    obj.run
  end

  def self.close!(conversation_identifier)
    return false unless Conversation.where(identifier: conversation_identifier).exists?

    Conversation.where(identifier: conversation_identifier).first.update(closed_at: Time.now)
    true
  end

  def initialize(participant, data)
    @data = data

    @participant = participant
    @conversation_identifier = data[:conversation_identifier]
    @from_identifier = data[:from_identifier]
    @message = data[:message]
    @to_number = data[:to_number]
    @from_number = data[:from_number]

    @available_operator = nil
    @conversation = nil
    @message_entry = nil
    @notify_operator_of_new_conversation = false
    @vistior = nil
  end

  def run
    if load_conversation
      @visitor = @conversation.visitor
      @available_operator = @conversation.user
    else
      find_next_available_operator
      if @available_operator.nil?
        send_autoresponder_message
        return
      end
      find_or_create_visitor
      create_conversation
      send_autoresponder_intro
    end
    create_message_entry
    notify_participants!
  end

  def send_chat_autoresponder_intro
    send_autoresponder_intro
  end

  private

  def autoresponder_intro_type
    text_message? ? Autoresponder::TEXT_INITIAL_CONNECTION : Autoresponder::CHAT_INITIAL_CONNECTION
  end

  def autoresponder_response_type
    text_message? ? Autoresponder::TEXT_NO_OPERATOR_AVAILABLE : Autoresponder::CHAT_NO_OPERATOR_AVAILABLE
  end

  def create_conversation
    @conversation = Conversation.create(
      identifier: @conversation_identifier,
      user_id: @available_operator.id,
      visitor_id: @visitor.id
    )
  end

  def create_message_entry
    messenger = operator_message? ? @available_operator : @visitor
    @message_entry = @conversation.messages.create!(messageable: messenger, message: @message)
  end

  def find_next_available_operator
    sql = 'SELECT COUNT(conversations.id) FROM conversations WHERE user_id = users.id'
    @available_operator = User.select("users.*, (#{sql}) AS conversation_count")
                              .where(user_status: [User::USER_STATUS_AVAILABLE, User::USER_STATUS_IDLE])
                              .order('conversation_count ASC, users.id ASC')
                              .first
  end

  def find_or_create_visitor
    @visitor = Visitor.where(identifier: @from_identifier).first
    return unless @visitor.nil?

    @visitor = Visitor.create(
      identifier: @from_identifier,
      user_id: @available_operator.id,
      to_number: @to_number,
      from_number: @from_number
    )
  end

  def load_conversation
    @conversation = Conversation.find_by_identifier(@conversation_identifier) if @conversation_identifier.present?
    if @conversation.nil?
      @notify_operator_of_new_conversation = true
      return false
    end

    # Reopen conversation
    @conversation.update_column(:closed_at, nil) unless @conversation.closed_at.nil?
    true
  end

  def mobile_conversation_check!
    return if @visitor.from_number.nil?

    @to_number = @visitor.to_number
    @from_number = @visitor.from_number
  end

  def notify_participants!
    payload = @notify_operator_of_new_conversation ? new_conversation_payload : new_message_payload
    ActionCable.server.broadcast "user_#{@available_operator.identifier}_channel", payload
    mobile_conversation_check!
    return if visitor_message? && text_message?

    text_message? ? operator_respond_to_text_message : operator_respond_to_chat_message
  end

  def new_conversation_payload
    {
      new_conversation: {
        name: @visitor.fake_name,
        identifier: @conversation.identifier,
        mobile: text_message?,
        created_at: @conversation.created_at,
        closed_at: @conversation.closed_at
      }
    }.to_camelback_keys
  end

  def new_message_payload
    {
      new_message: {
        name: @message_entry.messageable.name,
        conversation_identifier: @conversation.identifier,
        message: @message_entry.message,
        message_from: @message_entry.messageable_type,
        created_at: @message_entry.created_at
      }
    }.to_camelback_keys
  end

  def operator_respond_to_chat_message
    ActionCable.server.broadcast "visitor_#{@conversation.identifier}_channel", new_message_payload
  end

  def operator_respond_to_text_message
    CommunicationService::SmsManager.process(
      to_number: @visitor.from_number,
      from_number: @visitor.to_number,
      message: @message
    )
  end

  def operator_message?
    @participant == :operator
  end

  def send_autoresponder_intro
    AutoresponseManager.process(
      response_type: autoresponder_intro_type,
      conversation_identifier: @conversation_identifier,
      to_number: @to_number,
      from_number: @from_number
    )
  end

  def send_autoresponder_message
    AutoresponseManager.process(
      response_type: autoresponder_response_type,
      conversation_identifier: @conversation_identifier,
      to_number: @to_number,
      from_number: @from_number
    )
  end

  def text_message?
    @to_number.present? || @from_number.present?
  end

  def visitor_message?
    @participant == :visitor
  end
end

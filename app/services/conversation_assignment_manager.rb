class ConversationAssignmentManager
  def self.reassign_operator_conversations(user)
    obj = new(user)
    obj.run
  end

  def initialize(user)
    @user = user
    @conversation_ids = []
  end

  def run
    return if @user.nil?

    @user&.reload # This may be called from a socket, so make sure the latest user data is used.
    @conversation_ids = @user.conversation_ids

    reassign_conversations
    notify_user_of_reassignment
    true
  end

  private

  def find_next_available_operator
    sql = 'SELECT COUNT(conversations.id) FROM conversations WHERE user_id = users.id'
    User.select("users.*, (#{sql}) AS conversation_count")
        .where.not(id: @user.id)
        .where(user_status: [User::USER_STATUS_AVAILABLE, User::USER_STATUS_IDLE])
        .order('conversation_count ASC, users.id ASC')
        .first
  end

  def notify_user_of_reassignment
    payload = { conversations: [] }
    ActionCable.server.broadcast "user_#{@user.identifier}_channel", payload.to_camelback_keys
  end

  def reassign_conversations
    @conversation_ids.each do |conversation_id|
      conversation = Conversation.find(conversation_id)
      available_operator = find_next_available_operator
      if available_operator.nil?
        conversation.visitor.destroy
      else
        conversation.visitor.update_column(:user_id, available_operator.id)
        conversation.update_column(:user_id, available_operator.id)
        ActionCable.server.broadcast "user_#{available_operator.identifier}_channel", transfer_payload(conversation)
      end
      ActionCable.server.broadcast "user_#{@user.identifier}_channel", remove_conversation_payload(conversation)
    end
  end

  def remove_conversation_payload(conversation)
    {
      remove_conversation: {
        identifier: conversation.identifier
      }
    }.to_camelback_keys
  end

  def transfer_payload(conversation)
    {
      new_conversation: {
        name: conversation.visitor.fake_name,
        identifier: conversation.identifier,
        mobile: (conversation.visitor.to_number.present? || conversation.visitor.from_number.present?),
        created_at: conversation.created_at,
        closed_at: conversation.closed_at
      }
    }.to_camelback_keys
  end
end

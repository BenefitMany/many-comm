class AutoresponseManager
  def self.process(options)
    obj = new(options)
    obj.run
  end

  def initialize(options)
    @response_type = options[:response_type]
    @conversation_identifier = options[:conversation_identifier]
    @to_number = options[:to_number]
    @from_number = options[:from_number]

    @autoresponder = nil
    @message = nil
  end

  def run
    @autoresponder = load_autoresponder
    return false if @autoresponder.nil?

    @message = @autoresponder.message
    return false if already_responded?

    send_response
    log_response
    true
  end

  private

  def already_responded?
    AutoresponderLog.where(checksum: checksum).where('created_at > ?', 30.minutes.ago).exists?
  end

  def base_query
    Autoresponder.where(active: true)
  end

  def chat_initial_connection
    base_query.where(response_type: Autoresponder::CHAT_INITIAL_CONNECTION).first
  end

  def chat_no_operator_available
    base_query.where(response_type: Autoresponder::CHAT_NO_OPERATOR_AVAILABLE).first
  end

  def checksum
    @checksum ||= Digest::MD5.hexdigest([@message, @conversation_identifier].join('::'))
  end

  def load_autoresponder
    case @response_type
    when Autoresponder::CHAT_INITIAL_CONNECTION then chat_initial_connection
    when Autoresponder::TEXT_INITIAL_CONNECTION then text_initial_connection
    when Autoresponder::CHAT_NO_OPERATOR_AVAILABLE then chat_no_operator_available
    when Autoresponder::TEXT_NO_OPERATOR_AVAILABLE then text_no_operator_available
    end
  end

  def log_response
    AutoresponderLog.create(
      autoresponder_id: @autoresponder.id,
      message: @message,
      checksum: checksum
    )
  end

  def new_message_payload
    {
      new_message: {
        name: 'Autoresponder',
        conversation_identifier: @conversation_identifier,
        message: @message,
        message_from: 'user',
        created_at: Time.now
      }
    }.to_camelback_keys
  end

  def send_response
    text_message? ? respond_to_text_message : respond_to_chat_message
  end

  def text_initial_connection
    base_query.where(response_type: Autoresponder::TEXT_INITIAL_CONNECTION).first
  end

  def text_message?
    @to_number.present? || @from_number.present?
  end

  def text_no_operator_available
    base_query.where(response_type: Autoresponder::TEXT_NO_OPERATOR_AVAILABLE).first
  end

  def respond_to_chat_message
    ActionCable.server.broadcast "visitor_#{@conversation_identifier}_channel", new_message_payload
  end

  def respond_to_text_message
    CommunicationService::SmsManager.process(
      to_number: @from_number,
      from_number: @to_number,
      message: @message
    )
  end
end

module CommunicationService
  class SmsManager < ConnectionBase
    def self.process(options)
      obj = new(options)
      obj.run
    end

    def initialize(options)
      super(options)
      @to_number = options[:to_number]
      @from_number = options[:from_number]
      @message = options[:message]
    end

    def run
      return 'Invalid credentials for remote API' unless valid_credentials?

      # TODO: Add check to make sure number is still valid
      # load_phone_number
      # return 'Phone number entry not found' if @phone_number.nil?

      init_twilio_client
      send_message
      true
    end

    private

    def send_message
      @twilio.messages.create(from: @from_number, to: @to_number, body: @message)
    end
  end
end

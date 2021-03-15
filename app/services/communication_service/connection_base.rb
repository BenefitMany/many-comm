module CommunicationService
  class ConnectionBase
    def initialize(options)
      @options = options
      @application_url = MANYCOMM_BASE_URL
    end

    private

    def init_twilio_client
      @twilio = Twilio::REST::Client.new(
        TWILIO_API_KEY,
        TWILIO_API_SECRET,
        TWILIO_ACCOUNT_SID
      )
    end

    def valid_credentials?
      [
        TWILIO_API_KEY,
        TWILIO_API_SECRET,
        TWILIO_ACCOUNT_SID
      ].all?
    end
  end
end

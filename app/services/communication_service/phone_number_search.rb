module CommunicationService
  class PhoneNumberSearch < ConnectionBase
    def self.process(options)
      obj = new(options)
      obj.run
    end

    def initialize(options)
      super(options)
      @area_code = options[:area_code]
      @postal_code = options[:postal_code]
      @number_contains = options[:number_contains]
      @numbers = []
    end

    def run
      return [] unless valid_area_code?

      return [] unless valid_credentials?

      init_twilio_client
      search_numbers_by_area_code
      format_response
    end

    private

    def format_response
      @numbers.collect do |num|
        {
          number: num.friendly_name,
          postal_code: num.postal_code,
          capabilities: num.capabilities
        }
      end
    end

    def number_search_conditions
      conditions = { area_code: @area_code, sms_enabled: true, voice_enabled: true }
      conditions[:in_postal_code] = @postal_code unless @postal_code.to_s.blank?
      conditions[:contains] = @number_contains unless @number_contains.to_s.blank?
      conditions
    end

    def search_numbers_by_area_code
      @numbers = @twilio.available_phone_numbers('US').local.list(number_search_conditions)
    end

    def valid_area_code?
      @area_code.to_s.length == 3
    end
  end
end

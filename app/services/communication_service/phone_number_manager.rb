module CommunicationService
  class PhoneNumberManager < ConnectionBase
    def self.create(options)
      obj = new(options.merge(task: :create))
      obj.run
    end

    def self.update(options)
      obj = new(options.merge(task: :update))
      obj.run
    end

    def self.delete(options)
      obj = new(options.merge(task: :delete))
      obj.run
    end

    def initialize(options)
      super(options)
      @task = options[:task]
      @phone_number_id = options[:phone_number_id]
      @phone_number = nil
    end

    def run
      return 'Invalid credentials for remote API' unless valid_credentials?

      load_phone_number
      return 'Phone number entry not found' if @phone_number.nil?

      init_twilio_client
      process_task
      true
    end

    private

    def load_phone_number
      @phone_number = PhoneNumber.where(id: @phone_number_id).first
    end

    def phone_number_create
      incoming_phone_number = @twilio.incoming_phone_numbers.create(
        friendly_name: @phone_number.name,
        phone_number: @phone_number.number,
        sms_method: 'POST',
        sms_url: "#{@application_url}/webhooks/sms.xml"
      )
      @phone_number.update_column(twilio_sid: incoming_phone_number.sid)
    end

    def phone_number_delete
      @twilio.incoming_phone_numbers(@phone_number.twilio_sid).delete
    end

    def phone_number_update
      @twilio.incoming_phone_numbers(@phone_number.twilio_sid).update(friendly_name: @phone_number.name)
    end

    def process_task
      case @task
      when :create then phone_number_create
      when :update then phone_number_update
      when :delete then phone_number_delete
      end
    end
  end
end

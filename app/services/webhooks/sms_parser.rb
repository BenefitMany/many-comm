module Webhooks
  class SmsParser
    def self.process(params_data)
      obj = new(params_data)
      obj.run
    end

    def initialize(params_data)
      @data = params_data
    end

    def run
      cidentifier = conversation_identifier
      {
        from_number: @data[:from],
        to_number: @data[:to],
        from_identifier: cidentifier,
        conversation_identifier: cidentifier,
        message: @data[:body]
      }
    end

    private

    def conversation_identifier
      Digest::MD5.hexdigest([@data[:to], @data[:from]].join('::'))
    end
  end
end

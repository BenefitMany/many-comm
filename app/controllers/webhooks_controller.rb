class WebhooksController < ApplicationController
  skip_before_action :authorized?
  skip_before_action :authenticate

  def sms
    WebhookEntry.create(data: params.to_json)
    opts = Webhooks::SmsParser.process(JSON.parse(params.to_json, symbolize_names: true).to_snake_keys)
    ConversationManager.process_from_visitor(opts)

    head :ok
  end
end

require 'rails_helper'

describe MessageSerializer, type: :serializer do
  before do
    @message = FactoryBot.create(:message)
  end

  let(:resource_key) { :message }
  let(:resource) { @message }

  let(:expected_fields) do
    %i[
      id
      conversationId
      message
      messageableId
      messageableType
      createdAt
    ].sort
  end
end

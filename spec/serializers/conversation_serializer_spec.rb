require 'rails_helper'

describe ConversationSerializer, type: :serializer do
  before do
    @conversation = FactoryBot.create(:conversation)
  end

  let(:resource_key) { :conversation }
  let(:resource) { @conversation }

  let(:expected_fields) do
    %i[
      id
      identifier
      userId
      visitorId
      createdAt
      closedAt
    ].sort
  end
end

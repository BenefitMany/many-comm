require 'rails_helper'

describe PhoneNumberSerializer, type: :serializer do
  before do
    @phone_number = FactoryBot.create(:phone_number)
  end

  let(:resource_key) { :phoneNumber }
  let(:resource) { @phone_number }

  let(:expected_fields) do
    %i[
      id
      name
      number
      details
      createdAt
      deletedAt
    ].sort
  end
end

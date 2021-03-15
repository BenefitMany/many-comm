require 'rails_helper'

describe ProfileSerializer, type: :serializer do
  before do
    @user = FactoryBot.create(:user)
  end

  let(:resource_key) { :user }
  let(:resource) { @user }
  let(:resource_options) { { serializer_class: ProfileSerializer } }

  let(:expected_fields) do
    %i[
      id
      admin
      firstName
      lastName
      email
      timeZone
    ].sort
  end
end

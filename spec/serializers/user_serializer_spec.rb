require 'rails_helper'

describe UserSerializer, type: :serializer do
  before do
    @user = FactoryBot.create(:user)
  end

  let(:resource_key) { :user }
  let(:resource) { @user }

  let(:expected_fields) do
    %i[
      id
      admin
      firstName
      lastName
      email
      timeZone
      userStatus
      lastLoginAt
      activatedAt
      createdAt
    ].sort
  end
end

require 'rails_helper'

describe ApiSuccessSerializer, type: :serializer do
  before do
    @user = FactoryBot.create(:user)
  end

  let(:resource_key) { :user }
  let(:resource) { @user }
  let(:resource_options) { { serializer_class: ApiSuccessSerializer } }

  let(:expected_fields) do
    %i[
      id
    ].sort
  end
end

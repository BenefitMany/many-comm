require 'rails_helper'

RSpec.describe ChatAccessKey, type: :model do
  context 'associations and validations' do
  end

  context 'callbacks' do
    it 'should create an access key automatically' do
      chat_access_key = FactoryBot.create(:chat_access_key)
      expect(chat_access_key.access_key).to_not be_nil
    end
  end
end

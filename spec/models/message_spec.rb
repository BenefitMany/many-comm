require 'rails_helper'

RSpec.describe Message, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to :conversation }
    it { is_expected.to belong_to :messageable }
  end

  context 'instance methods' do
    context '#name' do
      it 'should return visitor if messagable_type is Visitor' do
        message = FactoryBot.create(:message, messageable: FactoryBot.create(:visitor))
        expect(message.name).to eq('Visitor')
      end

      it 'should return the users name if messagable_type is User' do
        user = FactoryBot.create(:user)
        message = FactoryBot.create(:message, messageable: user)
        expect(message.name).to eq([user.first_name, user.last_name].join(' '))
      end
    end

    context '#time' do
      it 'should give back a formatted string of the time' do
        message = FactoryBot.create(:message)
        expect(message.time).to_not be_nil
      end
    end
  end
end

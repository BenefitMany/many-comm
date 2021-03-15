require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  context 'associations and validations' do
    it { is_expected.to validate_presence_of(:name).with_message(/Enter name/) }
    it { is_expected.to validate_length_of(:name).is_at_most(100).with_message(/Name must have no more than 100 characters./) }
  end

  context 'instance methods' do
    context '#details' do
      it 'should change the details into a hash' do
        phone_number = FactoryBot.create(:phone_number)
        expect(phone_number.details.class).to be(Hash)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Visitor, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_one :conversation }
    it { is_expected.to have_many :messages }
  end

  context 'instance methods' do
    context '#fake_name' do
      it 'should give back a fake name' do
        visitor = FactoryBot.create(:visitor)
        expect(visitor.name).to_not be_nil
      end
    end
  end
end

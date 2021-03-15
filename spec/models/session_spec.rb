require 'rails_helper'

RSpec.describe Session, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'instance methods' do
    let(:session) do
      FactoryBot.create(:session, user_id: @test_admin_user.id)
    end

    describe 'Existing session(s) for user' do
      it 'should be removed if new session created' do
        Session.create!(user_id: session.user_id)
        expect(Session.where(user_id: session.user_id).count).to eq(1)
      end
    end
  end
end

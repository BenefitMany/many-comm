require 'rails_helper'
include ManyCommSpecHelpers

RSpec.describe Auth::CurrentUser, type: :service do
  before do
    @session = {}
    @test_user = FactoryBot.create(:user)
    authenticate_user(@test_user, @session)
  end

  context 'instance methods' do
    it 'should be equal if authenticated successfully' do
      current_user = Auth::CurrentUser.new(@session)
      expect(current_user.user_id).to eq(@test_user.id)
    end
  end
end

require 'rails_helper'

RSpec.describe Api::DashboardController, type: :controller do
  include ActiveJob::TestHelper

  context 'GET #show' do
    context 'with authenticated user' do
      before do
        authenticate_user(@test_admin_user)
      end

      it 'should return the stats successfully' do
        get :show
        expect(response).to be_successful
      end
    end

    context 'with unauthenticated user' do
      before do
        logout_user
      end

      it 'should be denied access' do
        get :show
        expect(response).to be_unauthorized
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Api::AutorespondersController, type: :controller do
  before do
    FactoryBot.create(
      :autoresponder,
      response_type: Autoresponder::CHAT_NO_OPERATOR_AVAILABLE
    )
    @autoresponder = FactoryBot.create(
      :autoresponder,
      response_type: Autoresponder::TEXT_NO_OPERATOR_AVAILABLE
    )
    authenticate_user(@test_admin_user)
  end

  let(:json_root_name) { 'autoresponder' }
  let(:object) { @autoresponder }
  let(:object_name) { 'autoresponder' }

  context 'GET #index' do
    context 'unauthorized user' do
      before { logout_user }
      it 'should fail if user not logged in' do
        get :index
        expect(response).to be_unauthorized
      end
    end

    it 'responds with a valid autoresponder list' do
      get :index
      expect(json['autoresponders']).to_not be_empty
    end
  end

  context 'PUT #update' do
    context 'with valid attributes' do
      it_behaves_like 'a PUT #update success' do
        let(:test_attrs) { { message: 'Thanks for the message.  We are unavailable' } }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a PUT #update failure' do
        let(:test_attrs) { { message: nil } }
      end
    end

    context 'with ID that does not exist' do
      subject { put :update, params: { id: 'foobar' } }
      it { is_expected.to be_not_found }
      specify { expect(json['error']).to eq('Autoresponder foobar not found') }
    end
  end
end

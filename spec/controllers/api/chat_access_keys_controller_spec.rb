require 'rails_helper'

RSpec.describe Api::ChatAccessKeysController, type: :controller do
  before do
    chat_access_keys = FactoryBot.create_list(:chat_access_key, 9)
    @chat_access_key = chat_access_keys.first
    authenticate_user(@test_admin_user)
  end

  let(:json_root_name) { 'chatAccessKey' }
  let(:object) { @chat_access_key }
  let(:object_name) { 'chat_access_key' }

  context 'GET #index' do
    context 'response should fail if user not logged in' do
      it_behaves_like 'a GET #index failure user not logged in'
    end

    context 'responds with a valid chat access key list' do
      it_behaves_like 'a GET #index success'
      it_behaves_like 'a GET non-paginated #index success'
    end
  end

  context 'POST #create' do
    context 'with valid attributes' do
      it 'should create the number successfully' do
        expect { post :create }.to change { ChatAccessKey.count }.by(1)
        expect(response).to be_successful
      end
    end
  end

  context 'DELETE #destroy' do
    context 'with ID that does exist' do
      it 'should destroy successfully' do
        delete :destroy, params: { id: @chat_access_key.id }
        expect(response).to be_successful
      end
    end

    context 'with ID that does not exist' do
      it 'should fail to delete' do
        delete :destroy, params: { id: 'foobar' }
        expect(json['error']).to eq('Chat access key foobar not found')
      end
    end
  end
end

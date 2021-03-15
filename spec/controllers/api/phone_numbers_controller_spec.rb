require 'rails_helper'

RSpec.describe Api::PhoneNumbersController, type: :controller do
  before do
    phone_numbers = FactoryBot.create_list(:phone_number, 9)
    @phone_number = phone_numbers.first
    authenticate_user(@test_admin_user)
  end

  let(:json_root_name) { 'phoneNumber' }
  let(:object) { @phone_number }
  let(:object_name) { 'phone_number' }

  context 'GET #index' do
    context 'response should fail if user not logged in' do
      it_behaves_like 'a GET #index failure user not logged in'
    end

    context 'responds with a valid user list' do
      it_behaves_like 'a GET #index success'
      it_behaves_like 'a GET non-paginated #index success'
    end

    context 'sort options' do
      it 'should sort by name' do
        get :index, params: { sort: 'name', order: 'ASC' }
        expect(response).to be_successful
      end

      it 'should sort by number' do
        get :index, params: { sort: 'number', order: 'ASC' }
        expect(response).to be_successful
      end

      it 'should sort by createdAt' do
        get :index, params: { sort: 'createdAt', order: 'ASC' }
        expect(response).to be_successful
      end

      it 'should sort by deletedAt' do
        get :index, params: { sort: 'deletedAt', order: 'ASC' }
        expect(response).to be_successful
      end
    end
  end

  context 'GET #show' do
    context 'responds with a valid phone number' do
      it_behaves_like 'a GET #show success'
    end

    context 'nonexistent phone number' do
      it_behaves_like 'a GET #show not found'
    end
  end

  context 'POST #create' do
    before do
      @phone_number_attrs = {
        name: 'Main Number',
        number: '+14125551212'
      }.to_camelback_keys
    end

    context 'with valid attributes' do
      it 'should create the number successfully' do
        allow(CommunicationService::PhoneNumberManager).to receive(:create).and_return(true)
        expect {
          post :create, params: { phoneNumber: @phone_number_attrs }
        }.to change { PhoneNumber.count }.by(1)
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a POST #create failure' do
        let(:test_attrs) { @phone_number_attrs.merge(name: nil) }
      end
    end
  end

  context 'PUT #update' do
    context 'with valid attributes' do
      it 'should update the number successfully' do
        allow(CommunicationService::PhoneNumberManager).to receive(:update).and_return(true)
        put :update, params: { id: @phone_number.id, phoneNumber: { name: 'Second number' } }
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a PUT #update failure' do
        let(:test_attrs) { { name: nil } }
      end
    end

    context 'with ID that does not exist' do
      subject { put :update, params: { id: 'foobar' } }
      it { is_expected.to be_not_found }
      specify { expect(json['error']).to eq('Phone number foobar not found') }
    end
  end

  context 'DELETE #destroy' do
    context 'with ID that does exist' do
      it 'should mark deleted successfully' do
        allow(CommunicationService::PhoneNumberManager).to receive(:delete).and_return(true)
        delete :destroy, params: { id: @phone_number.id }
        expect(response).to be_successful
      end
    end

    context 'with ID that does not exist' do
      it 'should fail to delete' do
        delete :destroy, params: { id: 'foobar' }
        expect(json['error']).to eq('Phone number foobar not found')
      end
    end
  end
end

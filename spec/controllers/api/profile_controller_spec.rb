require 'rails_helper'

RSpec.describe Api::ProfileController, type: :controller do
  before do
    #authenticate_user(@test_admin_user)
  end

  context 'GET #show' do
    context 'responds with a valid profile email' do
      before { authenticate_user(@test_admin_user) }
      subject { get :show }
      it { expect(subject).to be_successful }
      it { expect(json.keys).to eq(['profile']) }
    end
  end

  context 'should respond with no information if user is not logged in' do
    subject { get :show }
    it { is_expected.to be_unauthorized }
  end

  context 'PUT #update' do
    before do
      authenticate_user(@test_admin_user)
      @profile_params = {
        firstName: 'May',
        lastName: 'June',
        password: 'Simple123',
        passwordConfirmation: 'Simple123'
      }
    end

    let(:json_root_name) { 'profile' }
    let(:object) { @test_admin_user }
    let(:object_name) { 'profile' }

    context 'with valid attributes' do
      it_behaves_like 'a PUT #update success' do
        let(:test_attrs) { @profile_params }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a PUT #update failure' do
        let(:test_attrs) { @profile_params.merge(lastName: nil) }
      end
    end
  end
end

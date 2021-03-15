require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  include ActiveJob::TestHelper

  before do
    User.where.not(id: @test_admin_user.id).destroy_all
    users = FactoryBot.create_list(:user, 9)
    @user = users.first
    authenticate_user(@test_admin_user)
  end

  let(:json_root_name) { 'user' }
  let(:object) { @user }
  let(:object_name) { 'user' }

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

      it 'should sort by email' do
        get :index, params: { sort: 'email', order: 'ASC' }
        expect(response).to be_successful
      end

      it 'should sort by admin' do
        get :index, params: { sort: 'admin', order: 'ASC' }
        expect(response).to be_successful
      end

      it 'should sort by last_login_at' do
        get :index, params: { sort: 'lastLoginAt', order: 'ASC' }
        expect(response).to be_successful
      end
    end
  end

  # This is not tested here, but should work regardless, because @test_user would be deleted.
  # context 'respond with pagination numbers' do
  #   it_behaves_like 'a GET #index paginated (get 5 page numbers if 5+ pages exist) success'
  #   it_behaves_like 'a GET #index paginated (only get 1 page if not enough items) success'
  # end

  # context 'respond with all users without pagination' do
  #   subject { get :index, params: { paginate: false } }
  #   it { expect(subject).to be_success }
  #   it { expect(json['users'].size).to eq(User.count) }
  # end

  context 'GET #show' do
    context 'responds with a valid user' do
      it_behaves_like 'a GET #show success'
    end

    context 'nonexistent user' do
      it_behaves_like 'a GET #show not found'
    end
  end

  context 'POST #create admin' do
    before do
      @admin_user_attrs = {
        admin: true,
        first_name: 'Important',
        last_name: 'Person',
        email: 'admin@some-nonprofit-domain.com',
        phone: '617-555-1212',
        password: 'Simple123',
        password_confirmation: 'Simple123',
      }.to_camelback_keys
    end

    context 'with valid attributes' do
      it_behaves_like 'a POST #create success' do
        let(:test_attrs) { @admin_user_attrs }
      end
    end
  end

  context 'POST #create' do
    before do
      @user_attrs = {
        admin: true,
        first_name: 'Some',
        last_name: 'One',
        email: 'admin@some-nonprofit-domain.com',
        phone: '617-555-1212',
        password: 'Simple123',
        password_confirmation: 'Simple123'
      }.to_camelback_keys
    end

    context 'with valid attributes' do
      it_behaves_like 'a POST #create success' do
        let(:test_attrs) { @user_attrs }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a POST #create failure' do
        let(:test_attrs) { @user_attrs.merge(email: nil) }
      end
    end
  end

  describe 'POST #reset_password' do
    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    it 'should respond with success if id exists' do
      post :reset_password, params: { id: @user.id }
      expect(response).to be_successful
      expect(json['success']).to be_truthy
      expect(UserForgotPasswordJob).to have_been_enqueued.on_queue('default')
    end

    #not sure if this test is necessary as this method can't be done without a valid user id
    it 'should respond with error if id is not found' do
      post :reset_password, params: { id: '1234' }
      expect(response).not_to be_successful
      expect(json['error']).to be_truthy
      expect(UserForgotPasswordJob).to_not have_been_enqueued.on_queue('default')
    end
  end

  context 'PUT #update' do
    context 'with valid attributes' do
      it_behaves_like 'a PUT #update success' do
        let(:test_attrs) { { email: 'someonenew@gsnational.com', npn_attributes: {id: '', excluded_from_contest: 'false'} } }
      end
    end

    context 'with invalid attributes' do
      it_behaves_like 'a PUT #update failure' do
        let(:test_attrs) { { email: nil } }
      end
    end

    context 'with ID that does not exist' do
      subject { put :update, params: { id: 'foobar' } }
      it { is_expected.to be_not_found }
      specify { expect(json['error']).to eq('User foobar not found') }
    end
  end

  context 'DELETE #destroy' do
    context 'successful delete' do
      it_behaves_like 'a DELETE #destroy success'
    end

    context 'with ID that does not exist' do
      subject { delete :destroy, params: { id: 'foobar' } }
      it { is_expected.to be_not_found }
      specify { expect(json['error']).to eq('User foobar not found') }
    end
  end

  context 'callback methods' do
    before do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    context '#send_account_activation' do
      it 'should start a job to email the account activation' do
        FactoryBot.create(:user)
        expect(UserAccountActivationJob).to have_been_enqueued.on_queue('default')
      end
    end

    context '#send_email_verification' do
      it 'should start a job to send an email verification when the email address changes' do
        user = User.first
        user.update(new_email: 'new.email@gsnational.com')
        expect(UserEmailChangeJob).to have_been_enqueued.on_queue('default')
      end

      it 'should not start a job to send an email verification if the new_email was just be set to nil' do
        user = User.first
        user.update(new_email: 'new.email@gsnational.com')
        expect(UserEmailChangeJob).to have_been_enqueued.on_queue('default')
        clear_enqueued_jobs
        user.update(new_email: nil)
        expect(UserEmailChangeJob).to_not have_been_enqueued.on_queue('default')
      end
    end
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @user_attrs = %w[
      accessToken
      admin
      email
      firstName
      identifier
      lastName
      userId
    ].sort
  end

  describe 'GET #show' do
    context 'should response with valid info about the user if logged in' do
      before { authenticate_user(@test_admin_user) }
      subject { get :show }
      it { expect(subject).to be_successful }
      it { expect(json.keys.sort).to eq(@user_attrs) }
    end

    context 'should respond with no information if user is not logged in' do
      subject { get :show }
      it { expect(subject).to be_successful }
      it { expect(json.keys).to eq([]) }
    end
  end

  describe 'GET #valid_session' do
    context 'should response with success if user is logged in' do
      before { authenticate_user(@test_admin_user) }
      subject { get :valid_session }
      it { expect(subject).to be_successful }
      it { expect(json['validSession']).to be_truthy }
    end

    context 'should respond with false if a valid session does not exist' do
      subject { get :valid_session }
      it { expect(subject).to be_successful }
      it { expect(json['validSession']).to be_falsy }
    end
  end

  describe 'POST #create' do
    context 'should response with success if login is successful.' do
      before do
        @test_admin_user.password = 'Simple123'
        @test_admin_user.password_confirmation = 'Simple123'
        @test_admin_user.save
      end
      subject { post :create, params: { login: { email: @test_admin_user.email, password: 'Simple123' }} }
      it { expect(subject).to be_successful }
      it { expect(json.keys.sort).to eq(@user_attrs) }
    end

    context 'should respond with not_acceptable if login fails' do
      subject { post :create, params: { login: { email: @test_admin_user.email, password: 'bad_password' }} }
      it { expect(subject).to be_not_acceptable }
      it { expect(json['error']).to eq('Invalid email or password') }
    end
  end

  describe 'DELETE #destroy' do
    context 'should respond with success if login is successful' do
      before { authenticate_user(@test_admin_user) }
      subject { delete :destroy }
      it { expect(subject).to be_successful }
      it { expect(json['success']).to be_truthy }
    end

    context 'should respond with success even if no logged in session is detected' do
      subject { delete :destroy }
      it { expect(subject).to be_successful }
      it { expect(json['success']).to be_truthy }
    end
  end
end

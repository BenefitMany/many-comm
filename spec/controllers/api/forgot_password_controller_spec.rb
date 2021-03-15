require 'rails_helper'

RSpec.describe Api::ForgotPasswordController, type: :controller do
  include ActiveJob::TestHelper

  before do
    @test_user = FactoryBot.create(:user)
  end

  describe 'POST #create' do
    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    it 'should respond with success if email exists' do
      post :create, params: { email: @test_user.email }
      expect(response).to be_successful
      expect(json['success']).to be_truthy
      expect(UserForgotPasswordJob).to have_been_enqueued.on_queue('default')
    end

    it 'should respond with success even if email is not found' do
      post :create, params: { email: 'bad@email.com' }
      expect(response).to be_successful
      expect(json['success']).to be_truthy
      expect(UserForgotPasswordJob).to_not have_been_enqueued.on_queue('default')
    end
  end

  describe 'PUT #update' do
    before do
      @test_user.update_perishable_token!

      @valid_params = {
        token: @test_user.perishable_token,
        password: 'Simple123',
        password_confirmation: 'Simple123'
      }

      @invalid_token_params = {
        token: '0123456789',
        password: 'password',
        password_confirmation: 'password'
      }

      @unmatching_password_params = {
        token: @test_user.perishable_token,
        password: 'Password1',
        password_confirmation: 'Password123'
      }

      @tooshort_password_params = {
        token: @test_user.perishable_token,
        password: 'Simple1',
        password_confirmation: 'Simple1'
      }

      @nonumber_password_params = {
        token: @test_user.perishable_token,
        password: 'Password',
        password_confirmation: 'Password'
      }

      @nolowercase_password_params = {
        token: @test_user.perishable_token,
        password: 'PASSWORD1',
        password_confirmation: 'PASSWORD1'
      }

      @nouppercase_password_params = {
        token: @test_user.perishable_token,
        password: 'password1',
        password_confirmation: 'password1'
      }
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    it 'should response with success if passwords match' do
      post :update, params: @valid_params
      expect(response).to be_successful
      expect(json['success']).to be_truthy
      expect(UserUpdatedPasswordJob).to have_been_enqueued.on_queue('default')
    end

    it 'should respond with a not found response if token is not found' do
      post :update, params: @invalid_token_params
      expect(response).to be_not_found
      expect(json['error']).to eq('Invalid Token')
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end

    it 'should respond with a not acceptable response if passwords do not match' do
      post :update, params: @unmatching_password_params
      expect(response).to be_not_acceptable
      expect(json['error']).to eq(["Password confirmation doesn't match Password"])
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end

    it 'should respond with too short response if password is too short' do
      post :update, params: @tooshort_password_params
      expect(response).to be_not_acceptable
      expect(json['error']).to eq(["Password must be at least 8 characters long"])
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end

    it 'should respond with not acceptable response if password does not have a number' do
      post :update, params: @nonumber_password_params
      expect(response).to be_not_acceptable
      expect(json['error']).to eq(["Password must contain at least one number"])
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end

    it 'should respond with not acceptable response if password does not have a lowercase letter' do
      post :update, params: @nolowercase_password_params
      expect(response).to be_not_acceptable
      expect(json['error']).to eq(["Password must contain at least one lowercase letter"])
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end

    it 'should respond with not acceptable response if password does not have an uppercase letter' do
      post :update, params: @nouppercase_password_params
      expect(response).to be_not_acceptable
      expect(json['error']).to eq(["Password must contain at least one uppercase letter"])
      expect(UserUpdatedPasswordJob).to_not have_been_enqueued.on_queue('default')
    end
  end
end

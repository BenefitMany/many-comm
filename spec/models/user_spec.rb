require 'rails_helper'

RSpec.describe User, type: :model do
  include ActiveJob::TestHelper

  context 'associations and validations' do
    subject { FactoryBot.create(:user, email: 'asdf@asdf.com') }

    it { is_expected.to have_many :conversations }
    it { is_expected.to have_many :messages }
    it { is_expected.to have_many :sessions }
    it { is_expected.to have_many :visitors }

    it { is_expected.to validate_presence_of(:email).with_message(/Enter email address/) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message(/Email has already been taken/) }
    it { is_expected.to validate_presence_of(:first_name).with_message(/Enter first name/) }
    it { is_expected.to validate_presence_of(:last_name).with_message(/Enter last name/) }
  end

  context 'instance methods' do
    let(:user) { FactoryBot.create(:user) }

    context '#update_password_reset_token!' do
      it 'should set/change the password_reset_token' do
        token = user.perishable_token
        user.update_perishable_token!
        expect(user.perishable_token).to_not eq(token)
      end
    end

    context '#name' do
      it 'should give back the full name' do
        expect(user.name).to eq([user.first_name, user.last_name].join(' '))
      end
    end
  end

  context 'new_email' do
    let(:user) { FactoryBot.create(:user) }

    it 'should save the new email if new email is valid' do
      expect(user.update(new_email: 'dog@dog.com')).to be_truthy
    end

    it 'should fail if email is not valid' do
      new_user = FactoryBot.build(:user, email: 'dog-dog.com')
      new_user.valid?
      expect(new_user.errors.messages.values.flatten).to include('Email is invalid')
    end

    it 'should fail if new_email is not valid' do
      user.update(new_email: 'dog-dog.com')
      expect(user.errors.messages.values.flatten).to include('New email is invalid')
    end

    it 'should fail to save the new_email if already in use' do
      FactoryBot.create(:user, email: 'dog@dog.com')
      user.update(new_email: 'dog@dog.com')
      expect(user.errors.messages.values.flatten).to include('New email is already in use')
    end
  end

  context 'skip_activation_email' do
    before do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    it 'should not skip the sending the activation email' do
      FactoryBot.create(:user)
      expect(UserAccountActivationJob).to have_been_enqueued.on_queue('default')
    end

    it 'should skip the sending the activation email' do
      FactoryBot.create(:user, skip_activation_email: true)
      expect(UserAccountActivationJob).to_not have_been_enqueued.on_queue('default')
    end
  end
end

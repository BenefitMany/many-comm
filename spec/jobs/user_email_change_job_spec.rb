require 'rails_helper'

RSpec.describe UserEmailChangeJob, type: :job do
  context '.perform' do
    let(:user) { FactoryBot.create(:user) }

    it 'should send out email for a given user id' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(message_delivery).to receive(:deliver_now)
      expect(SendgridManager).to receive(:user_new_email_verification).with(user).and_return(message_delivery)
      expect { UserEmailChangeJob.new.perform(user.id) }.to_not raise_error
      change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end

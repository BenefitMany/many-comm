require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  context 'POST #sms' do
    before do
      @twilio_params = {
        ToCountry: 'US',
        ToState: 'PA',
        SmsMessageSid: 'SM113318785f1c663cb1e17a1313bf3996',
        NumMedia: '0',
        ToCity: 'MC KEES ROCKS',
        FromZip: '15212',
        SmsSid: 'SM113318785f1c663cb1e17a1313bf3996',
        FromState: 'PA',
        SmsStatus: 'received',
        FromCity: 'PITTSBURGH',
        Body: 'Hi',
        FromCountry: 'US',
        To: '+14121112222',
        ToZip: '15205',
        NumSegments: '1',
        MessageSid: 'SM113318785f1c663cb1e17a1313bf3996',
        AccountSid: 'ACf1bf2dee1234ca11e43a14da86ef1234',
        From: '+14123334444',
        ApiVersion: '2010-04-01',
        controller: 'webhooks',
        action: 'sms',
        id: '1',
        format: 'xml'
      }
    end

    context 'with data from twilio' do
      it 'should process the message successfully' do
        FactoryBot.create(:user, user_status: User::USER_STATUS_AVAILABLE)
        Conversation.destroy_all
        allow(CommunicationService::SmsManager).to receive(:process).and_return(true)
        post :sms, params: @twilio_params
        expect(response).to be_successful
        expect(Conversation.count).to eq(1)
      end
    end
  end
end

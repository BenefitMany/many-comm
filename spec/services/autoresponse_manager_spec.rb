require 'rails_helper'
include ManyCommSpecHelpers

RSpec.describe AutoresponseManager, type: :service do
  before(:all) do
    Autoresponder.delete_all

    @chat_autoresponder = FactoryBot.create(
      :autoresponder,
      active: true,
      response_type: Autoresponder::CHAT_NO_OPERATOR_AVAILABLE
    )
    @text_autoresponder = FactoryBot.create(
      :autoresponder,
      active: true,
      response_type: Autoresponder::TEXT_NO_OPERATOR_AVAILABLE
    )
  end

  context 'Incoming chat message' do
    before do
      @chat_options = {
        response_type: Autoresponder::CHAT_NO_OPERATOR_AVAILABLE,
        conversation_identifier: '11373d3ce886c2a3e022438cf1b73cd1',
        to_number: nil,
        from_number: nil
      }
      @checksum = Digest::MD5.hexdigest([@chat_autoresponder.message,@chat_options[:conversation_identifier]].join('::'))
    end

    it 'should respond with CHAT_NO_OPERATOR_AVAILABLE' do
      expect(AutoresponseManager.process(@chat_options)).to be_truthy
    end

    it 'should log the autoresponse' do
      expect { AutoresponseManager.process(@chat_options) }.to change { AutoresponderLog.count }.by(1)
    end

    it 'should not respond if already responded to the visitor within 30 minutes' do
      log = @chat_autoresponder.autoresponder_logs.create(message: @chat_autoresponder.message, checksum: @checksum)
      log.update_column(:created_at, 20.minutes.ago)
      expect(AutoresponseManager.process(@chat_options)).to be_falsey
    end

    it 'should respond again if first response was more than 30 minutes ago' do
      log = @chat_autoresponder.autoresponder_logs.create(message: @chat_autoresponder.message, checksum: @checksum)
      log.update_column(:created_at, 40.minutes.ago)
      expect(AutoresponseManager.process(@chat_options)).to be_truthy
    end

    it 'should return false if the autoresponder is not active' do
      @chat_autoresponder.update(active: false)
      expect(AutoresponseManager.process(@chat_options)).to be_falsey
    end
  end

  context 'Incoming text message' do
    before do
      @text_options = {
        response_type: Autoresponder::TEXT_NO_OPERATOR_AVAILABLE,
        conversation_identifier: 'd9d32ffff80d8970e43f4f4c65edfb49',
        to_number: '+14128889999',
        from_number: '+14123334444'
      }

      @checksum = Digest::MD5.hexdigest([
        @text_autoresponder.message,
        @text_options[:conversation_identifier]
      ].join('::'))
    end

    it 'should respond with TEXT_NO_OPERATOR_AVAILABLE' do
      allow(CommunicationService::SmsManager).to receive(:process).and_return(true)
      expect(AutoresponseManager.process(@text_options)).to be_truthy
    end

    it 'should log the autoresponse' do
      allow(CommunicationService::SmsManager).to receive(:process).and_return(true)
      expect { AutoresponseManager.process(@text_options) }.to change { AutoresponderLog.count }.by(1)
    end

    it 'should not respond if already responded to the visitor within 30 minutes' do
      log = @text_autoresponder.autoresponder_logs.create(message: @text_autoresponder.message, checksum: @checksum)
      log.update_column(:created_at, 20.minutes.ago)
      expect(AutoresponseManager.process(@text_options)).to be_falsey
    end

    it 'should respond again if first response was more than 30 minutes ago' do
      allow(CommunicationService::SmsManager).to receive(:process).and_return(true)
      log = @text_autoresponder.autoresponder_logs.create(message: @text_autoresponder.message, checksum: @checksum)
      log.update_column(:created_at, 40.minutes.ago)
      expect(AutoresponseManager.process(@text_options)).to be_truthy
    end

    it 'should return false if the autoresponder is not active' do
      @text_autoresponder.update(active: false)
      expect(AutoresponseManager.process(@text_options)).to be_falsey
    end
  end
end

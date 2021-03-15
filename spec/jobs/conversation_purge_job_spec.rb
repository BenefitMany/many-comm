require 'rails_helper'

RSpec.describe ConversationPurgeJob, type: :job do
  context '.perform' do
    let(:conversation) { FactoryBot.create(:conversation) }

    it 'should purge the conversation if 5 minutes has passed' do
      conversation.update_column(:closed_at, 5.minutes.ago)
      expect(ConversationPurgeJob.new.perform(conversation.id)).to be_truthy
    end

    it 'should return false if conversation has been marked unresolved' do
      conversation.update_column(:closed_at, nil)
      expect(ConversationPurgeJob.new.perform(conversation.id)).to be_falsy
    end

    it 'should not purge the conversation if less than 5 minutes has passed' do
      conversation.update_column(:closed_at, 3.minutes.ago)
      expect(ConversationPurgeJob.new.perform(conversation.id)).to be_falsy
    end

    it 'should return false if conversation is no longer available' do
      conversation.destroy
      expect(ConversationPurgeJob.new.perform(conversation.id)).to be_falsy
    end
  end
end

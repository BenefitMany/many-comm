require 'rails_helper'

RSpec.describe AutoResolveInactiveConversationsJob, type: :job do
  context '.perform_now' do
    it 'should got through the process successfully' do
      allow(CronJob::AutoResolveInactiveConversations).to receive(:process).and_return(true)
      expect(AutoResolveInactiveConversationsJob.perform_now).to be_truthy
    end
  end
end

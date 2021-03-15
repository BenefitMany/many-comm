require 'rails_helper'
include ManyCommSpecHelpers

RSpec.describe ManyCommSystem do
  context 'Class methods' do
    context 'auto_resolve_inactive_conversations' do
      it 'should start the process to autoresolve inactive conversations' do
        expect(AutoResolveInactiveConversationsJob).to receive(:perform_later).once
        ManyCommSystem.auto_resolve_inactive_conversations
      end
    end
  end
end

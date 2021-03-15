FactoryBot.define do
  factory :message do
    before(:create) do |msg|
      msg.conversation_id = FactoryBot.create(:conversation).id if msg.conversation_id.blank?
      msg.messageable = FactoryBot.create(:visitor) if msg.messageable.blank?
    end

    message { 'This is the message' }
  end
end

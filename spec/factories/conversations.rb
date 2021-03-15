FactoryBot.define do
  factory :conversation do
    before(:create) do |conversation|
      conversation.user_id = FactoryBot.create(:user).id if conversation.user_id.blank?
      if conversation.visitor_id.blank?
        conversation.visitor_id = FactoryBot.create(:visitor, user_id: conversation.user_id).id
      end
    end

    identifier { SecureRandom.uuid.gsub('-', '') }
    closed_at { nil }
  end
end

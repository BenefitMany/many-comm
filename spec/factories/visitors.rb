FactoryBot.define do
  factory :visitor do
    before(:create) do |visitor|
      visitor.user_id = FactoryBot.create(:user).id if visitor.user_id.blank?
    end

    fake_name { Forgery::Name.full_name }
    identifier { SecureRandom.uuid.gsub('-', '') }
    properties { { name: 'String' } }
  end
end

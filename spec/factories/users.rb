FactoryBot.define do
  factory :user do
    first_name { Forgery('name').first_name }
    last_name { Forgery('name').last_name }
    admin { false }
    email
    password { 'Simple123' }
    password_confirmation { 'Simple123' }
    password_digest { '$2a$10$PMleNF4H55DQDewexhnpe.YYFGdwo8vzyLwqDWZqttifVnV8S3KKO' }
    password_change { false }
  end
end

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.ninja"
  end
end

FactoryBot.define do
  factory :phone_number do
    name { 'Hotline' }
    number { '(111) 222-3333' }
    details { { fax: true, mms: true, sms: true, voice: true } }
  end
end

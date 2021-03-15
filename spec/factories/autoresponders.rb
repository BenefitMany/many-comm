FactoryBot.define do
  factory :autoresponder do
    response_type { Autoresponder::TEXT_NO_OPERATOR_AVAILABLE }
    active { false }
    message { 'No operator available' }
  end
end

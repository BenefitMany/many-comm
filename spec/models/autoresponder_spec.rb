require 'rails_helper'

RSpec.describe Autoresponder, type: :model do
  context 'associations and validations' do
    it { is_expected.to have_many :autoresponder_logs }

    it { is_expected.to validate_presence_of(:message).with_message(/Enter message/) }
  end
end

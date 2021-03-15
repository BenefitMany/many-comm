require 'rails_helper'

RSpec.describe AutoresponderLog, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to :autoresponder }

    it { is_expected.to validate_presence_of(:message).with_message(/Enter message/) }
    it { is_expected.to validate_presence_of(:checksum).with_message(/Enter checksum/) }
  end
end

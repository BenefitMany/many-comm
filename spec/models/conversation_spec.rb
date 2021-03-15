require 'rails_helper'

RSpec.describe Conversation, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :visitor }
    it { is_expected.to have_many :messages }
  end
end

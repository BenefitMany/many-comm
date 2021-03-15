require 'rails_helper'

RSpec.describe UserLoginEntry, type: :model do
  context 'associations and validations' do
    it { is_expected.to belong_to :user }
  end
end

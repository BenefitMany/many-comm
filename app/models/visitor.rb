class Visitor < ApplicationRecord
  belongs_to :user
  has_many :messages, as: :messageable
  has_one :conversation, dependent: :destroy

  before_create :randomify_name

  def name
    fake_name
  end

  private

  def randomify_name
    self.fake_name = [Faker::Color.color_name, Faker::Creature::Animal.name].join(' ')
  end
end

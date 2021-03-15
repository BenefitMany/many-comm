class Conversation < ApplicationRecord
  belongs_to :visitor
  belongs_to :user
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
end

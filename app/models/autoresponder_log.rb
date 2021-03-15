class AutoresponderLog < ApplicationRecord
  belongs_to :autoresponder

  validates :message, presence: { message: 'Enter message' }
  validates :checksum, presence: { message: 'Enter checksum' }
end

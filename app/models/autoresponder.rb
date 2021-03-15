class Autoresponder < ApplicationRecord
  CHAT_INITIAL_CONNECTION = 'chat_initial_connection'.freeze
  TEXT_INITIAL_CONNECTION = 'text_initial_connection'.freeze
  CHAT_NO_OPERATOR_AVAILABLE = 'chat_no_operator_available'.freeze
  TEXT_NO_OPERATOR_AVAILABLE = 'text_no_operator_available'.freeze
  RESPONDER_TYPES = [
    CHAT_INITIAL_CONNECTION,
    TEXT_INITIAL_CONNECTION,
    CHAT_NO_OPERATOR_AVAILABLE,
    TEXT_NO_OPERATOR_AVAILABLE
  ].freeze

  has_many :autoresponder_logs, dependent: :destroy

  validates :message,
            presence: { message: 'Enter message' },
            length: { maximum: 100, too_long: 'Message must have no more than 100 characters.' }
end

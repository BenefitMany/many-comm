class ConversationSerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :identifier,
             :user_id,
             :visitor_id,
             :created_at,
             :closed_at

  has_many :messages, if: -> { should_render_association }

  def created_at
    created_at_null_or_timestamp
  end

  def closed_at
    object.closed_at&.in_time_zone('Eastern Time (US & Canada)')&.to_s(:short_stamp)
  end
end

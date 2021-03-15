class MessageSerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :conversation_id,
             :message,
             :messageable_id,
             :messageable_type,
             :created_at

  def created_at
    created_at_null_or_timestamp
  end
end

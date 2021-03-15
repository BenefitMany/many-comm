class ChatAccessKeySerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :access_key,
             :accessed,
             :created_at,
             :deleted_at

  def created_at
    created_at_null_or_timestamp
  end

  def deleted_at
    deleted_at_null_or_timestamp
  end
end

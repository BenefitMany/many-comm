class AutoresponderSerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :response_type,
             :active,
             :status_changed_at,
             :message,
             :created_at

  def status_changed_at
    object.status_changed_at&.in_time_zone('Eastern Time (US & Canada)')&.to_s(:short_stamp)
  end

  def created_at
    created_at_null_or_timestamp
  end
end

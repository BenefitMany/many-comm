module AttributeHelpers
  extend ActiveSupport::Concern

  def activated_at_null_or_timestamp
    object.activated_at&.in_time_zone('Eastern Time (US & Canada)')&.to_s(:short_stamp)
  end

  def created_at_null_or_timestamp
    object.created_at&.in_time_zone('Eastern Time (US & Canada)')&.to_s(:short_stamp)
  end

  # def created_on
  #   object.created_at.to_date.to_s(:basic_date)
  # end

  # def created_by
  #   return '' if object.creator_id.blank?
  #
  #   object.creator.slice(:first_name, :last_name).values.join(' ')
  # end

  def deleted_at_null_or_timestamp
    object.deleted_at&.in_time_zone('Eastern Time (US & Canada)')&.to_s(:short_stamp)
  end

  def should_render_association
    @instance_options[:include_associations]
  end
end

class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true
  belongs_to :conversation

  def name
    return 'Visitor' if messageable_type == 'Visitor'

    [messageable.first_name, messageable.last_name].join(' ')
  end

  def time
    created_at.to_s(:basic_time_without_leading_zero)
  end
end

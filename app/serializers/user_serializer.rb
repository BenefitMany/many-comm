class UserSerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :admin,
             :first_name,
             :last_name,
             :email,
             :time_zone,
             :activated_at,
             :user_status,
             :created_at,
             :last_login_at

  has_many :user_login_entries, if: -> { should_render_association }

  def last_login_at
    last_login = object.user_login_entries.order('created_at DESC').first
    last_login.nil? ? 'Never' : last_login.created_at.in_time_zone('Eastern Time (US & Canada)').to_s(:short_stamp)
  end

  def activated_at
    activated_at_null_or_timestamp
  end

  def created_at
    created_at_null_or_timestamp
  end
end

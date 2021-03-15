class ProfileSerializer < ActiveModel::Serializer
  include AttributeHelpers

  attributes :id,
             :admin,
             :first_name,
             :last_name,
             :email,
             :time_zone
end

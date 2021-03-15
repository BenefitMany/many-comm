class PhoneNumber < ApplicationRecord
  validates :name,
            presence: { message: 'Enter name' },
            length: { maximum: 100, too_long: 'Name must have no more than 100 characters.' }
end

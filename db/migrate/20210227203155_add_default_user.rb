class AddDefaultUser < ActiveRecord::Migration[5.2]
  def change
    user = User.create(
      first_name: 'Admin',
      last_name: 'User',
      email: 'admin@user.com',
      admin: true,
      time_zone: 'Pacific Time',
      skip_activation_email: true
    )
    user.password = 'Simple123!'
    user.password_confirmation = 'Simple123!'
    user.save!
  end
end

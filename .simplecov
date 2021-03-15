SimpleCov.minimum_coverage 70
SimpleCov.start 'rails' do
  add_group 'Serializers', 'app/serializers'
  # add_group 'Channels', 'app/channels'
  add_group 'Services', 'app/services'
  add_group 'Model Concerns', 'app/models/concerns'
  add_group 'Controller Concerns', 'app/controllers/concerns'
  add_group 'Libraries', 'lib'

  # The two methods here are difficult to test, but they are not working then nothing will work.
  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/controllers/concerns/application_route_methods.rb'

  add_filter 'lib/assets'
  add_filter 'lib/mina'
  add_filter 'lib/tasks'

  # If I use channels then I will test them.
  add_filter 'app/channels'
end

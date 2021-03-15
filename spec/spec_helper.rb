unless ENV['NOCOV']
  require 'simplecov'

  cov_formats = [SimpleCov::Formatter::HTMLFormatter]
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(cov_formats)
end

ENV['RAILS_ENV'] = 'test'
ENV['AUTH_NET_TEST_MODE'] = 'false'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec_api_documentation'
require 'webmock/rspec'
require 'shoulda-matchers'
require 'database_cleaner'
require 'response_code_matchers'
require 'resque_spec'
require 'rspec/active_job'
require 'email-spec'

require 'zonebie/rspec' if ENV['ZONEBIE']

WebMock.disable_net_connect!(allow_localhost: true)

# We have lots of stuff in the support folder, so be specific about load order
Dir["#{File.dirname(__FILE__)}/../spec/support/auth/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../spec/support/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../spec/support/example_groups/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../spec/support/shared_examples/*.rb"].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end


puts "rspec pid: #{Process.pid}"

trap 'USR1' do
  threads = Thread.list

  puts
  puts "=" * 80
  puts "Received USR1 signal; printing all #{threads.count} thread backtraces."

  threads.each do |thr|
    description = thr == Thread.main ? "Main thread" : thr.inspect
    puts
    puts "#{description} backtrace: "
    puts thr.backtrace.join("\n")
  end

  puts "=" * 80
end


RSpec.configure do |config|
  config.define_derived_metadata(file_path: Regexp.new('/spec/services/')) do |metadata|
    metadata[:type] = :service
  end

  config.include RSpec::ActiveJob
  config.include Requests::DisableFlashSweeping, type: :controller
  config.include Requests::JsonHelpers, type: :controller
  config.include Auth::SecurityHelpers, type: :controller
  config.include Auth::SecurityHelpers, type: :service
  config.include ManyCommSpecHelpers, type: :mailer
  config.include ManyCommSpecHelpers, type: :model
  config.include ManyCommSpecHelpers, type: :controller
  config.include ManyCommSpecHelpers, type: :helper
  config.include ManyCommSpecHelpers, type: :serializer
  config.include ManyCommSpecHelpers, type: :service
  config.include ManyCommSpecHelpers, type: :job
  config.include ManyCommSpecHelpers, type: :routing
  config.include ManyCommSpecHelpers, type: :rake
  config.include ResponseCodeMatchers, type: :controller

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end


  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random
  Kernel.srand config.seed

  # config.filter_run_excluding performance: true
  # config.filter_run_excluding slow: true

  config.before(:each) do
    # ResqueSpec.reset!
  end

  config.before(:all) do
    DeferredGarbageCollection.start
    default_data_info
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
    # FileUtils.rm_rf('public/uploads')
  end

  config.after(:each) do
    # ActiveJob::Base.queue_adapter.enqueued_jobs = []
    # ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end

require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

include Auth::SecurityHelpers

RspecApiDocumentation.configure do |config|
  config.format = [:json, :combined_text, :html]
  config.curl_host = 'http://localhost:3000'
  config.api_name = 'ManyComm API'
  config.keep_source_order = true
end

module ManyCommAcceptanceHelpers
  include Requests::JsonHelpers

  def success
    200
  end
end

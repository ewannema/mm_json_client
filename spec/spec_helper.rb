########################################################
#                   Test Coverage
########################################################
require 'simplecov'
SimpleCov.start

########################################################
#                  Mock Web Requests
########################################################
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.include WebMock::API
end

########################################################
#                  Standard Startup
########################################################
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mm_json_client'

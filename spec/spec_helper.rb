require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'voicemaker/cli'
include Voicemaker

FAKE_API_KEY = 'fake-test-key'
ENV['VOICEMAKER_API_KEY'] = FAKE_API_KEY

def require_mock_server!
  result = HTTP.get('http://localhost:3000/')
  result = result.parse
  raise "Please start the mock server" unless result['mockserver'] == 'online'
rescue HTTP::ConnectionError
  # :nocov:
  raise "Please start the mock server"
  # :nocov:
end

def clean_tmp_dir
  system 'rm -rf spec/tmp/*'
  'spec/tmp'
end

RSpec.configure do |c|
  c.filter_run_excluding :require_test_api_key unless ENV['VOICEMAKER_TEST_API_KEY']

  c.before :suite do
    PRODUCTION_API_BASE = API.base_uri
    TEST_API_BASE = "http://localhost:3000"
    API.base_uri = TEST_API_BASE
    system 'mkdir -p spec/tmp'
  end
end

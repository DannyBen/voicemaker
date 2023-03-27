require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'voicemaker/cli'
include Voicemaker

def require_mock_server!
  result = HTTP.get('http://localhost:3000/')
  result = result.parse
  raise 'Please start the mock server' unless result['mockserver'] == 'online'
rescue HTTP::ConnectionError
  # :nocov:
  raise 'Please start the mock server'
  # :nocov:
end

def clean_tmp_dir
  system 'rm -rf spec/tmp/*'
  'spec/tmp'
end

def clean_cache_dir
  API.cache.flush
end

PRODUCTION_API_ROOT = API::ROOT
TEST_API_ROOT = 'http://localhost:3000'
FAKE_API_KEY = 'fake-test-key'

RSpec.configure do |c|
  c.filter_run_excluding :require_test_api_key unless ENV['VOICEMAKER_TEST_API_KEY']

  c.before :suite do
    ENV['VOICEMAKER_API_KEY'] = FAKE_API_KEY
    ENV['VOICEMAKER_CACHE_DIR'] = 'spec/tmp/cache'

    API.root = TEST_API_ROOT
    API.key = FAKE_API_KEY
    API.cache.disable

    system 'mkdir -p spec/tmp'
  end
end

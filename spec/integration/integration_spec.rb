require 'spec_helper'

describe 'Integration', :require_test_api_key do
  subject { CLI.runner }

  before do
    Voicemaker::API.root = PRODUCTION_API_ROOT
    Voicemaker::API.key = ENV['VOICEMAKER_TEST_API_KEY']
  end

  after do
    Voicemaker::API.root = TEST_API_ROOT
    Voicemaker::API.key = FAKE_API_KEY
  end

  # Test all commands as defined in the spec config
  config = YAML.load_file 'spec/integration/commands.yml'
  config.each do |name, command|
    context name do
      it "works" do
        args = command.is_a?(Array) ? command : command.split(' ')
        expect { subject.run args }
          .to output_approval("integration/#{name}")
          .except(/\/(\d)+\-/, '#')        
      end
    end
  end
end

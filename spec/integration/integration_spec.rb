require 'spec_helper'

describe 'Integration', :require_test_api_key do
  subject { CLI.runner }

  before do
    Voicemaker::API.base_uri = PRODUCTION_API_BASE
    ENV['VOICEMAKER_API_KEY'] = ENV['VOICEMAKER_TEST_API_KEY']
  end

  after do
    Voicemaker::API.base_uri = TEST_API_BASE
    ENV['VOICEMAKER_API_KEY'] = FAKE_API_KEY
  end

  # Test all commands as defined in the spec config
  config = YAML.load_file 'spec/integration/commands.yml'
  config.each do |name, command|
    context name do
      it "works" do
        args = command.is_a?(Array) ? command : command.split(' ')
        expect { subject.run args }
          .to output_approval("integration/#{name}")
          .except(/(\d)+/, '#')        
      end
    end
  end
end

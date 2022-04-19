require 'spec_helper'

describe TTSParams do
  subject { described_class.new params }
  let(:params) { { voice: 'Emma', text: 'hello' } }
  before { require_mock_server! }

  describe '#api_params' do
    it "returns a hash suitable for API consumption" do
      expect(subject.api_params.to_yaml).to match_approval 'tts_params/api_params'
    end
  end

  describe '#inspect' do
    it "returns a string with API params" do
      expect(subject.inspect).to match_approval 'tts_params/inspect'
    end
  end
end

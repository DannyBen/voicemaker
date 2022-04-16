require 'spec_helper'

describe API do
  subject { API.new api_key }
  before { require_mock_server! }

  let(:api_key) { FAKE_API_KEY }
  let(:params) { YAML.load_file params_file }
  let(:params_file) { 'spec/fixtures/config.yml' }

  describe '#new' do
    it "initializes with api key" do
      expect(subject.api_key).to eq api_key
    end
  end

  describe '#voices' do
    it "returns a hash of voices" do
      expect(subject.voices.to_yaml).to match_approval('api/voices')
    end

    context "with a search array argument" do
      it "returns only the voices that include at least one of the words" do
        expect(subject.voices(['kid']).to_yaml).to match_approval('api/voices-search')
      end
    end
  end

  describe '#generate' do
    it "generates an mp3 file and returns its url" do
      expect(subject.generate params).to match_approval('api/generate')
    end

    context "on error" do
      let(:params_file) { 'spec/fixtures/config-error.yml' }

      it "raises BadResponse" do
        expect { subject.generate params }.to raise_approval('api/generate-bad-response')
      end
    end
  end
end

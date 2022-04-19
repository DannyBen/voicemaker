require 'spec_helper'

describe API do
  subject { described_class }
  before { require_mock_server! }

  describe '::root' do
    it "returns the root URI" do
      expect(subject.root).to eq TEST_API_ROOT
    end
  end

  describe '::key' do
    it "returns the API key" do
      expect(subject.key).to eq FAKE_API_KEY
    end
  end

  describe '::cache_life' do
    it "returns the default 4 hours" do
      expect(subject.cache_life).to eq '4h'
    end
  end
  
  describe '::cache_dir' do
    it "returns the default cache dir" do
      expect(subject.cache_dir).to eq 'spec/tmp/cache'
    end
  end

  describe '::get' do
    it "returns a parsed response from the API" do
      expect(subject.get('/list').to_yaml).to match_approval('api/list')
    end
  end

  describe '::post' do
    it "returns a parsed response from the API" do
      expect(subject.post('/api').to_yaml).to match_approval('api/api')
    end
  end
end

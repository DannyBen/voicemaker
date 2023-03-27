require 'spec_helper'

describe Voices do
  before { require_mock_server! }

  describe '#all' do
    it 'returns a hash with all voices' do
      expect(subject.all.to_yaml).to match_approval('voices/all')
    end
  end

  describe '#search' do
    it 'returns a hash of voices matching all the provided strings' do
      expect(subject.search('kid', 'gb').to_yaml).to match_approval('voices/search')
    end
  end
end

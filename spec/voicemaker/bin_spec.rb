require 'spec_helper'

describe 'bin/voicemaker' do
  subject { CLI.runner }

  context "on error" do
    it "displays it nicely" do
      expect(`bin/voicemaker tts --voice unknown 2>&1`).to match_approval('cli/error')
    end
  end
end

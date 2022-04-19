require 'spec_helper'

describe Commands::TTSCommand do
  subject { CLI.runner }
  before { require_mock_server! }
  let(:config) { 'spec/fixtures/config.yml' }
  let(:outpath) { 'spec/tmp/out.mp3' }
  let(:textfile) { 'spec/fixtures/text.txt' }
  let(:voice) { 'ai3-Jony' }

  describe '--help' do
    it "shows full usage" do
      expect { subject.run %w[tts --help] }.to output_approval 'cli/tts/help'
    end
  end

  describe '--voice VOICE --text TEXT' do
    it "returns a URL to the generated MP3" do
      expect { subject.run %W[tts --voice #{voice} --text hi --debug] }
        .to output_approval 'cli/tts/voice-text'
    end
  end

  describe '--file PATH' do
    it "loads text from file" do
      expect { subject.run %W[tts --voice #{voice} --file #{textfile} --debug] }
        .to output_approval 'cli/tts/voice-file'
    end
  end

  describe '--config PATH' do
    it "loads config from file" do
      expect { subject.run %W[tts --config #{config} --text hi --debug] }
        .to output_approval 'cli/tts/config-text'
    end
  end

  describe '--save PATH' do
    before { system "rm -f #{outpath} "}

    it "saves the audio file" do
      expect { subject.run %W[tts --voice #{voice} --text hi --save #{outpath} --debug] }
        .to output_approval 'cli/tts/save'
      expect(File).to exist outpath
    end
  end
end

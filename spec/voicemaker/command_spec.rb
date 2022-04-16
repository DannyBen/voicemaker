require 'spec_helper'

describe Command do
  subject { CLI.runner }
  before { require_mock_server! }

  # Test all commands as defined in the spec config
  config = YAML.load_file 'spec/voicemaker/commands.yml'
  config.each do |name, command|
    context name do
      it "works" do
        args = command.is_a?(Array) ? command : command.split(' ')
        expect { subject.run args }.to output_approval("cli/#{name}")
      end
    end
  end

  # Test other non-standard cases
  context "generate" do
    before { system "rm -f out.mp3" }

    it "downloads the mp3 file" do
      expect { subject.run %w[generate] }.to output_approval('cli/generate')
      expect(File).to exist('out.mp3')
    end
  end

  context "generate with invalid config" do
    it "raises an error" do
      expect { subject.run %w[generate noconfig.yml] }.to raise_approval('cli/generate-invalid-config')
    end
  end

  context "generate with custom filename" do
    before { system "rm -f #{outfile}" }
    let(:outfile) { 'spec/tmp/tts.mp3' }

    it "raises an error" do
      expect { subject.run %W[generate config.yml #{outfile}] }.to output_approval('cli/generate-custom-outfile')
      expect(File).to exist(outfile)
    end
  end

  context "voices with --save" do
    before { system "rm -f #{outfile}" }
    let(:outfile) { 'spec/tmp/out.json' }

    it "saves the output to a file" do
      expect { subject.run %W[voices --save #{outfile}] }.to output_approval("cli/voices-save")
      expect(File).to exist(outfile)
    end
  end
end

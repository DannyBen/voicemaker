require 'spec_helper'

describe Commands::VoicesCommand do
  subject { CLI.runner }
  before { require_mock_server! }
  let(:config) { 'spec/fixtures/config.yml' }
  let(:outpath) { 'spec/tmp/out.mp3' }

  describe 'voices' do
    it "shows the full voices list" do
      expect { subject.run %w[voices] }.to output_approval 'cli/voices/no-args'
    end
  end

  describe '--help' do
    it "shows full usage" do
      expect { subject.run %w[voices --help] }.to output_approval 'cli/voices/help'
    end
  end

  describe '--count' do
    it "adds the count to the result" do
      expect { subject.run %w[voices kid --count] }.to output_approval 'cli/voices/count'
    end
  end

  describe '--verbose' do
    it "shows a full YAML output" do
      expect { subject.run %w[voices --verbose] }.to output_approval 'cli/voices/verbose'
    end
  end

  describe '--verbose --count' do
    it "shows a full YAML output with count" do
      expect { subject.run %w[voices --verbose --count] }.to output_approval 'cli/voices/verbose-count'
    end
  end

  describe "SEARCH..." do
    it "only shows the matching voices" do
      expect { subject.run %w[voices kid gb] }.to output_approval 'cli/voices/search'
    end
  end

  describe "--save PATH" do
    before { system "rm -f #{outfile}" }
    let(:outfile) { 'spec/tmp/out.txt' }

    it "saves the output to a file" do
      expect { subject.run %W[voices --save #{outfile}] }
        .to output_approval "cli/voices/save"
      expect(File).to exist(outfile)
      expect(File.read outfile).to match_approval "cli/voices/save-content"
    end
  end

  describe '--save PATH --verbose' do
    before { system "rm -f #{outfile}" }
    let(:outfile) { 'spec/tmp/out.yaml' }

    it "saves the full YAML output to a file" do
      expect { subject.run %W[voices --verbose --save #{outfile}] }
        .to output_approval "cli/voices/save-verbose"
      expect(File).to exist(outfile)
      expect(File.read outfile).to match_approval "cli/voices/save-verbose-content"
    end
  end

end

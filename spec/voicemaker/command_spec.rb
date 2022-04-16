require 'spec_helper'

describe Command do
  subject { CLI.runner }
  before { require_mock_server! }
  let(:config) { 'spec/fixtures/config.yml' }
  let(:outpath) { 'spec/tmp/out.mp3' }

  describe 'no args' do
    it "shows usage" do
      expect { subject.run [] }.to output_approval 'cli/usage'
    end
  end

  describe 'voices' do
    it "shows a list of voices" do
      expect { subject.run %w[voices] }.to output_approval 'cli/voices'
    end

    context "with a search string" do
      it "only shows the matching voices" do
        expect { subject.run %w[voices kid] }.to output_approval 'cli/voices-search'
      end
    end

    context "with multiple search strings" do
      it "only shows the voices matching any (or) string" do
        expect { subject.run %w[voices kid gb] }.to output_approval 'cli/voices-search2'
      end
    end

    context "with --save" do
      before { system "rm -f #{outfile}" }
      let(:outfile) { 'spec/tmp/out.json' }

      it "saves the output to a file" do
        expect { subject.run %W[voices --save #{outfile}] }.to output_approval("cli/voices-save")
        expect(File).to exist(outfile)
      end
    end
  end

  describe 'new' do
    before { clean_tmp_dir }
    let(:config) { 'spec/tmp/test.yml' }

    it "creates a sample config" do
      expect { subject.run %W[new #{config}] }.to output_approval('cli/new')
      expect(File).to exist config
      expect(File.read config).to match_approval('cli/new-output')
    end
  end

  describe "generate" do
    before { clean_tmp_dir }

    it "downloads the mp3 file" do
      expect { subject.run %W[generate #{config} #{outpath}] }
        .to output_approval('cli/generate')

      expect(File).to exist(outpath)
    end

    context "without output path" do
      let(:config) { 'spec/tmp/tada.yml' }

      before do
        clean_tmp_dir
        system "cp spec/fixtures/config.yml #{config}"
      end

      it "deduces the output path from the config" do
        expect { subject.run %W[generate #{config}] }
          .to output_approval('cli/generate-auto-outpath')

        expect(File).to exist('spec/tmp/tada.mp3')
      end
    end

    context "with invalid config" do
      it "raises an error" do
        expect { subject.run %w[generate noconfig.yml out.mp3] }
          .to raise_approval('cli/generate-invalid-config')
      end
    end
  end

  describe 'batch', :focus do
    before { clean_tmp_dir }
    let(:indir) { 'spec/fixtures/indir' }
    let(:outdir) { 'spec/tmp' }

    it "makes multiple generation calls" do
      expect { subject.run %W[batch #{indir} #{outdir}] }
        .to output_approval('cli/batch')

      expect(Dir["#{outdir}/*"].to_yaml).to match_approval('cli/batch-dir')
    end
  end

end

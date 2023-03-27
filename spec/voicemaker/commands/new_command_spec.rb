require 'spec_helper'

describe Commands::NewCommand do
  subject { CLI.runner }

  let(:config) { 'spec/tmp/spec.yml' }
  let(:project) { 'spec/tmp/project' }

  describe 'no args' do
    it 'shows usage' do
      expect { subject.run %w[new] }.to output_approval 'cli/new/usage'
    end
  end

  describe '--help' do
    it 'shows full usage' do
      expect { subject.run %w[new --help] }.to output_approval 'cli/new/help'
    end
  end

  describe 'config' do
    before { system "rm -f #{config}" }

    it 'creates a sample config file' do
      expect { subject.run %W[new config #{config}] }.to output_approval 'cli/new/config'
      expect(File).to exist config
    end

    context 'when the file exists' do
      before { system "touch #{config}" }

      it 'raises an error' do
        expect { subject.run %W[new config #{config}] }.to raise_approval 'cli/new/config-error'
      end
    end
  end

  describe 'project' do
    before { system "rm -rf #{project}" }

    it 'creates a sample project dir' do
      expect { subject.run %W[new project #{project}] }.to output_approval 'cli/new/project'
      expect(Dir).to exist project
      expect(Dir["#{project}/**/*"].sort.to_yaml).to match_approval 'cli/new/project-ls'
    end

    context 'when the project config file exists' do
      before { system "mkdir -p #{project} && touch #{project}/config.yml" }

      it 'raises an error' do
        expect { subject.run %W[new project #{project}] }.to raise_approval 'cli/new/project-error'
      end
    end
  end
end

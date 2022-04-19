require 'spec_helper'

describe Commands::ProjectCommand do
  subject { CLI.runner }
  let(:project) { 'spec/fixtures/project' }

  describe 'no args' do
    it "shows usage" do
      expect { subject.run %W[project] }.to output_approval 'cli/project/usage'
    end
  end

  describe '--help' do
    it "shows full usage" do
      expect { subject.run %W[project --help] }.to output_approval 'cli/project/help'
    end
  end

  describe 'PATH' do
    before { system "rm -f #{project}/out/*.{mp3,wav}" }

    it "batch-generates all text files in the project" do
      expect { subject.run %W[project #{project} --debug] }.to output_approval 'cli/project/path'
    end
  end
end

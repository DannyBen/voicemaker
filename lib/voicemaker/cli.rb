require 'mister_bin'
require 'voicemaker/command'

module Voicemaker
  class CLI
    def self.runner
      MisterBin::Runner.new handler: Command
    end
  end
end

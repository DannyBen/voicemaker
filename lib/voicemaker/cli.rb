require 'lp'
require 'mister_bin'
require 'voicemaker/commands/base'
require 'voicemaker/commands/voices_command'
require 'voicemaker/commands/tts_command'
require 'voicemaker/commands/new_command'
require 'voicemaker/commands/project_command'

module Voicemaker
  class CLI
    def self.runner
      router = MisterBin::Runner.new version: VERSION,
        header: "Voicemaker Text-to-Speech",
        footer: "API Documentation: https://developer.voicemaker.in/apidocs"

      router.route "voices", to: Commands::VoicesCommand
      router.route "tts", to: Commands::TTSCommand
      router.route "new", to: Commands::NewCommand
      router.route "project", to: Commands::ProjectCommand

      router

    end
  end
end

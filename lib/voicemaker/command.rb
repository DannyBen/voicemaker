require 'lp'
require 'down'
require 'mister_bin'
require 'voicemaker/refinements'

module Voicemaker
  class Command < MisterBin::Command
    using Voicemaker::Refinements

    help "Voicemaker API\n\n  API Documentation:\n  https://developer.voicemaker.in/apidocs"
    version Voicemaker::VERSION

    usage "voicemaker voices [--save PATH] [SEARCH...]"
    usage "voicemaker config [CONFIG]"
    usage "voicemaker generate [CONFIG OUTPUT]"
    usage "voicemaker (-h|--help|--version)"

    command "langs", "Get list of supported languages"
    command "voices", "Get list of voices, optionally in a given language"
    command "config", "Generate sample config file"
    command "generate", "Generate text to speech file"

    option "-l --language LANG", "Limit results to a specific language"
    option "-s --save PATH", "Save output to file. When using a command that generates data (like langs or voices), the output will be saved in YAML format"

    param "SEARCH", "Provide one or more text strings to search for (case insensitive)"
    param "CONFIG", "Path to config file [default: config.yml]"
    param "OUTPUT", "Path to output MP3 or WAV [default: out.mp3"

    environment "VOICEMAKER_API_KEY", "Your Voicemaker API key [required]"
    environment "VOICEMAKER_CACHE_DIR", "API cache diredctory [default: cache]"
    environment "VOICEMAKER_CACHE_LIFE", <<~EOF
      API cache life. These formats are supported:
      off - No cache
      20s - 20 seconds
      10m - 10 minutes
      10h - 10 hours
      10d - 10 days
    EOF
    environment "VOICEMAKER_API_URI", "Override the API URI [default: #{Voicemaker::API.base_uri}]"

    example "voicemaker langs"
    example "voicemaker voices en-us"
    example "voicemaker voices en-us female"

    def voices_command
      send_output api.voices(args['SEARCH'])
    end

    def generate_command
      say "Sending API request"
      url = api.generate config
      say "Downloading !txtgrn!#{url}"
      Down.download url, destination: output
      say "Saved !txtgrn!#{output}"
    end

  private

    def send_output(data)
      if save
        say "saved #{save}"
        File.write save, data.to_yaml
      else
        lp data
      end
    end

    def api
      @api ||= Voicemaker::API.new(api_key, base_uri: ENV['VOICEMAKER_API_URI'])
    end

    def api_key
      ENV['VOICEMAKER_API_KEY'] or raise MissingAuth, "Please set the 'VOICEMAKER_API_KEY' environment variable"
    end

    def config
      YAML.load_file config_path
    end

    def save
      args['--save']
    end

    def config_path
      args['CONFIG'] || 'config.yml'
    end

    def output
      args['OUTPUT'] || 'out.mp3'
    end

  end
end

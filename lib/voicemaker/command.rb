require 'lp'
require 'down'
require 'mister_bin'

module Voicemaker
  class Command < MisterBin::Command
    help "Voicemaker API\n\n  API Documentation:\n  https://developer.voicemaker.in/apidocs"
    version Voicemaker::VERSION

    usage "voicemaker voices [--save PATH] [SEARCH...]"
    usage "voicemaker new CONFIG"
    usage "voicemaker generate CONFIG OUTPUT"
    usage "voicemaker (-h|--help|--version)"

    command "langs", "Get list of supported languages"
    command "voices", "Get list of voices, optionally in a given language"
    command "new", "Generate a sample config file"
    command "generate", "Generate text to speech file. The output filename will be the same as the config filename, with the proper mp3 or wav extension"

    option "-l --language LANG", "Limit results to a specific language"
    option "-s --save PATH", "Save output to output YAML file"

    param "SEARCH", "Provide one or more text strings to search for (case insensitive)"
    param "CONFIG", "Path to config file"
    param "OUTPUT", "Path to output mp3/wav file"

    environment "VOICEMAKER_API_KEY", "Your Voicemaker API key [required]"

    example "voicemaker voices en-us"
    example "voicemaker voices --save out.yml en-us"
    example "voicemaker voices en-us female"
    example "voicemaker new test.yml"
    example "voicemaker generate test.yml out.mp3"

    def voices_command
      send_output api.voices(args['SEARCH'])
    end

    def new_command
      template = File.expand_path "../sample.yml", __dir__
      content = File.read template
      File.write config_path, content
      say "Saved #{config_path}"
    end

    def generate_command
      raise InputError, "Cannot find config file #{config_path}" unless File.exist? config_path
      say "Sending API request"
      url = api.generate config
      say "Downloading !txtgrn!#{url}"
      Down.download url, destination: output_path
      say "Saved !txtgrn!#{output_path}"
    end

  private

    def send_output(data)
      if save
        say "Saved #{save}"
        File.write save, data.to_yaml
      else
        lp data
      end
    end

    def api
      @api ||= Voicemaker::API.new(api_key)
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
      args['CONFIG']
    end

    def output_path
      args['OUTPUT']
    end

  end
end

require 'lp'
require 'mister_bin'

module Voicemaker
  class Command < MisterBin::Command
    help "Voicemaker API\n\n  API Documentation:\n  https://developer.voicemaker.in/apidocs"
    version Voicemaker::VERSION

    usage "voicemaker voices [--save PATH] [SEARCH...]"
    usage "voicemaker new CONFIG"
    usage "voicemaker generate CONFIG [OUTPUT]"
    usage "voicemaker batch INDIR OUTDIR"
    usage "voicemaker (-h|--help|--version)"

    command "voices", "Get list of voices, optionally in a given language"
    command "new", "Generate a sample config file"
    command "generate", "Generate audio file. The output filename will be the same as the config filename, with the proper mp3 or wav extension"
    command "batch", "Generate multiple audio files from multiple config files"

    option "-l --language LANG", "Limit results to a specific language"
    option "-s --save PATH", "Save output to output YAML file"

    param "SEARCH", "Provide one or more text strings to search for (case insensitive AND search)"
    param "CONFIG", "Path to config file"
    param "OUTPUT", "Path to output mp3/wav file. If not provided, the filename will be the same as the config file, with wav/mp3 extension"
    param "INDIR", "Path to input directory, containing config YAML files"
    param "OURDIR", "Path to output directory, where mp3/wav files will be saved"

    environment "VOICEMAKER_API_KEY", "Your Voicemaker API key [required]"
    environment "VOICEMAKER_API_HOST", "Override the API host URL"

    example "voicemaker voices en-us"
    example "voicemaker voices --save out.yml en-us"
    example "voicemaker voices en-us female"
    example "voicemaker new test.yml"
    example "voicemaker generate test.yml out.mp3"
    example "voicemaker batch configs out"

    def voices_command
      send_output api.voices(args['SEARCH'])
    end

    def new_command
      template = File.expand_path "../sample.yml", __dir__
      content = File.read template
      File.write args['CONFIG'], content
      say "Saved #{args['CONFIG']}"
    end

    def generate_command
      config_path = args['CONFIG']
      raise InputError, "Cannot find config file #{config_path}" unless File.exist? config_path
      outpath = args['OUTPUT'] || outpath_from_config(config_path)
      generate config_path, outpath
    end

    def batch_command
      files = Dir["#{args['INDIR']}/*.yml"].sort
      raise InputError, "No config files in #{args['INDIR']}" if files.empty?

      files.each do |config_path|
        extension = extension_from_config(config_path)
        basename = File.basename config_path, '.yml'
        outpath = "#{args['OUTDIR']}/#{basename}.#{extension}"
        generate config_path, outpath
        puts ""
      end
    end

  private

    def generate(config_path, outpath)
      params = YAML.load_file config_path

      say "Config : !txtgrn!#{config_path}"
      api.download outpath, params do |url|
        say "URL    : !txtblu!#{url}"
      end

      say "Path   : !txtblu!#{outpath}"
    end

    def send_output(data)
      save = args['--save']
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

    def outpath_from_config(config_path)
      ext = extension_from_config config_path
      config_path.gsub(/yml$/, ext)
    end

    def extension_from_config(config_path)
      YAML.load_file(config_path)['OutputFormat']
    end

  end
end

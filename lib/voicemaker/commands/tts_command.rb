module Voicemaker
  module Commands
    class TTSCommand < Base
      help 'Generate audio files from text'

      usage 'voicemaker tts [options]'
      usage 'voicemaker tts (-h|--help)'

      option '-v --voice NAME', 'Voice ID or Webname'
      option '-t --text TEXT', 'Text to say'
      option '-f --file PATH', 'Load text from file'
      option '-c --config PATH', 'Use a YAML configuration file'
      option '-s --save PATH', <<~USAGE
        Save audio file.
        If not provided, a URL to the audio file will be printed instead.
        When used with the --config option, omit the file extension, as it will be determined based on the config file.
      USAGE
      option '-d --debug', 'Show API parameters'

      api_environment

      example 'voicemaker tts --voice ai3-Jony --text "Hello world" --save out.mp3'
      example 'voicemaker tts -v ai3-Jony --file hello.txt --save out.mp3'
      example 'voicemaker tts --config english-female.yml -f text.txt -s outfile'

      def run
        verify_args
        tts = Voicemaker::TTS.new(**tts_params)
        say "url: b`#{tts.url}`"

        if output_file
          tts.save output_file
          say "out: b`#{output_file}`"
        end

        show_details tts if args['--debug']
      end

    private

      def show_details(tts)
        lp tts.params.api_params
      end

      def verify_args
        raise InputError, 'Please provide either --config or --voice' unless args['--config'] || args['--voice']
        raise InputError, 'Please provide either --text or --file' unless args['--text'] || args['--file']
      end

      def voice
        args['--voice']
      end

      def text
        args['--text'] || text_from_file
      end

      def output_file
        args['--save']
      end

      def tts_params
        result = if config
          YAML.load_file(config).transform_keys(&:to_sym)
        else
          {}
        end

        result[:voice] = voice if voice
        result[:text] = text
        result[:output_format] = File.extname(output_file)[1..] if output_file
        result
      end

      def config
        return unless args['--config']
        raise InputError, "Cannot find config file #{args['--config']}" unless File.exist? args['--config']

        args['--config']
      end

      def text_from_file
        path = args['--file']
        raise InputError, "Cannot find text file: #{path}" unless File.exist? path

        File.read path
      end
    end
  end
end

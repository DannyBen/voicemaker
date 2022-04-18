module Voicemaker
  module Commands
    class ProjectCommand < Base
      help "Create multiple audio files"

      usage "voicemaker project PATH [--debug]"
      usage "voicemaker project (-h|--help)"

      param "PATH", "Path to the project directory"

      option "--debug", "Show API parameters"

      api_environment

      example "voicemaker project sample-project"

      def run
        text_files.each do |file|
          text = File.read file
          tts.params.text = text
          audio_file = File.basename(file, '.txt') + ".#{tts.params.output_format}"
          output_path = "#{outdir}/#{audio_file}"

          say "in:  !txtblu!#{file}"
          say "url: !txtblu!#{tts.url}"
          say "out: !txtblu!#{output_path}"
          show_details tts if args['--debug']

          tts.save output_path
          say "---"
        end
      end

    private

      def tts
        @tts ||= Voicemaker::TTS.new **config
      end

      def show_details(tts, output: nil)
        lp tts.params.api_params
      end

      def text_files
        @text_files ||= Dir["#{indir}/*.txt"]
      end

      def config
        @config ||= begin
          raise InputError, "Cannot find config file: #{config_path}" unless File.exist? config_path
          YAML.load_file(config_path).transform_keys &:to_sym
        end
      end

      def config_path
        "#{project_dir}/config.yml"
      end

      def project_dir
        args['PATH']
      end

      def indir
        "#{project_dir}/in"
      end

      def outdir
        "#{project_dir}/out"
      end

      def text_from_file
        path = args['--file']
        raise InputError, "Cannot find text file: #{path}" unless File.exist? path
        File.read path
      end

    end
  end
end
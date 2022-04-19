module Voicemaker
  module Commands
    class NewCommand < Base
      help "Create a new config file or a project directory"

      usage "voicemaker new config PATH"
      usage "voicemaker new project DIR"
      usage "voicemaker new (-h|--help)"

      command "config", "Create a config file to be used with the 'voicemaker tts' command"
      command "project", "Generate a project directory to be used with the 'voicemaker project' command"

      param "PATH", "Path to use for creating the config file"
      param "DIR", "Directory name for creating the project structure"

      example "voicemaker new config test.yml"
      example "voicemaker new project sample-project"

      def config_command
        copy_config_template args['PATH']
      end

      def project_command
        base = args['DIR']
        copy_config_template "#{base}/config.yml"
        Dir.mkdir "#{base}/in" unless Dir.exist? "#{base}/in"
        Dir.mkdir "#{base}/out" unless Dir.exist? "#{base}/out"
        File.write "#{base}/in/sample1.txt", "hello"
        File.write "#{base}/in/sample2.txt", "hello"
        say "created in and out folders in #{base}"
      end

    protected

      def copy_config_template(path)
        raise InputError, "File already exists: #{path}" if File.exist? path
        content = File.read template
        File.deep_write path, content
        say "saved #{path}"
      end

      def template
        @template ||= File.expand_path "../../sample.yml", __dir__
      end

    end
  end
end

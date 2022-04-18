module Voicemaker
  module Commands
    class VoicesCommand < Base
      help "Get a list of available voices"

      usage "voicemaker voices [--save PATH --count] [SEARCH...]"
      usage "voicemaker voices (-h|--help)"

      option "-s --save PATH", "Save output to output YAML file"
      option "-c --count", "Add number of voices to the result"

      param "SEARCH", "Provide one or more text strings to search for (case insensitive AND search)"

      api_environment

      example "voicemaker voices en-us"
      example "voicemaker voices --save out.yml en-us"
      example "voicemaker voices en-us female"

      def run
        result = voices.search *args['SEARCH']
        result['count'] = result.count if args['--count']
        send_output result
      end

    private

      def voices
        @voices ||= Voicemaker::Voices.new
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

    end
  end
end
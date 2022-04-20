module Voicemaker
  module Commands
    class VoicesCommand < Base
      help "Get a list of available voices"

      usage "voicemaker voices [--save PATH --count --verbose] [SEARCH...]"
      usage "voicemaker voices (-h|--help)"

      option "-s --save PATH", "Save output to output YAML file"
      option "-v --verbose", "Show the full voices data structure"
      option "-c --count", "Add number of voices to the result"

      param "SEARCH", "Provide one or more text strings to search for (case insensitive AND search)"

      api_environment

      example "voicemaker voices en-us"
      example "voicemaker voices --save out.yml en-us"
      example "voicemaker voices en-us female"
      example "voicemaker voices en-us --verbose"

      def run
        result = voices.search *args['SEARCH']
        result['count'] = result.count if args['--count'] and args['--verbose']
        send_output result
      end

    private

      def voices
        @voices ||= Voicemaker::Voices.new
      end

      def send_output(data)
        if args['--save']
          save data
        elsif args['--verbose']
          lp data
        else
          puts compact(data)
        end
      end

      def save(data)
        File.write args['--save'], args['--verbose'] ? data.to_yaml : compact(data)
        say "saved #{args['--save']}"
      end

      def compact(data)
        result = data.values.map do |v|
          [
            v['VoiceId'].ljust(16),
            # v['VoiceWebname'].ljust(10),
            v['Language'],
            v['VoiceGender'].ljust(10),
            v['Engine']
          ].join "\t"
        end

        result.push "count: #{data.count}" if args['--count']
        result.join "\n"
      end

    end
  end
end
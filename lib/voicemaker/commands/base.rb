module Voicemaker
  module Commands
    class Base < MisterBin::Command
      class << self
        def api_environment
          environment 'VOICEMAKER_API_KEY', 'Your Voicemaker API key [required]'
          environment 'VOICEMAKER_API_HOST', 'Override the API host URL'
          environment 'VOICEMAKER_CACHE_DIR', 'API cache diredctory [default: cache]'
          environment 'VOICEMAKER_CACHE_LIFE', <<~USAGE
            API cache life. These formats are supported:
            off - No cache
            20s - 20 seconds
            10m - 10 minutes
            10h - 10 hours
            10d - 10 days
          USAGE
        end
      end
    end
  end
end

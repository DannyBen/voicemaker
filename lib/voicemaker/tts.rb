require 'down'

module Voicemaker
  class TTS
    attr_reader :params

    def initialize(params = {})
      @params = TTSParams.new params
    end

    # Returns the URL for the generated file
    def url
      response = API.post "api", params.api_params
      url = response['path']
      raise BadResponse, "Received empty URL: #{response}" unless url
      url
    end

    # Saves the audio file
    def save(outpath)
      Down.download url, destination: outpath
    end
  end
end
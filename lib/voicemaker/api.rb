require 'http'
require 'down'

module Voicemaker
  class API
    attr_reader :api_key

    class << self
      attr_writer :base_uri

      def base_uri
        @base_uri ||= ENV['VOICEMAKER_API_HOST'] || 'https://developer.voicemaker.in/voice'
      end
    end

    def initialize(api_key)
      @api_key = api_key
    end

    # Returns a list of voices, with optional search criteria (array)
    def voices(search = nil)
      search = nil if search&.empty?
      response = HTTP.auth(auth_header).get "#{base_uri}/list"
      raise BadResponse, "#{response.status}\n#{response.body}" unless response.status.success?
      voices = response.parse.dig 'data', 'voices_list'
      raise BadResponse, "Unexpected response: #{response}" unless voices

      if search
        voices.select do |voice|
          search_string = voice.values.join(' ').downcase
          search.all? { |query| search_string.include? query.downcase }
        end
      else
        voices
      end
    end

    # Returns the URL for the generated file
    def generate(params = {})
      response = HTTP.auth(auth_header).post "#{base_uri}/api", json: params
      if response.status.success?
        response.parse['path']
      else
        raise BadResponse, "#{response.status}\n#{response.body}"
      end
    end

    # Calls the API and saves the file
    def download(outpath, params = {})
      path = generate params
      yield path if block_given?
      Down.download path, destination: outpath
    end

  protected 

    def base_uri
      self.class.base_uri
    end

    def auth_header
      "Bearer #{api_key}"
    end

  end
end
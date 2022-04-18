require 'lightly'
require 'http'

module Voicemaker
  class API

    class << self
      attr_writer :root, :key, :cache_life, :cache_dir

      def root
        @root ||= ENV['VOICEMAKER_API_ROOT'] || 'https://developer.voicemaker.in/voice'
      end

      def key
        @key ||= ENV['VOICEMAKER_API_KEY'] || raise(MissingAuth, "Please set the 'VOICEMAKER_API_KEY' environment variable")
      end

      def cache_life
        @cache_life ||= ENV['VOICEMAKER_CACHE_LIFE'] || '4h'
      end

      def cache_dir
        @cache_dir ||= ENV['VOICEMAKER_CACHE_DIR'] || 'cache'
      end

      # Performs HTTP GET and cache it
      # Returns a parsed body on success
      # Raises BadResponse on error
      def get(endpoint, params = {})
        cache.get "#{root}/#{endpoint}+#{params}" do
          response = get! endpoint, params
          response.parse
        end
      end

      # Performs HTTP GET
      # Returns a parsed body on success
      # Raises BadResponse on error
      def get!(endpoint, params = {})
        response = HTTP.auth(auth_header).get "#{root}/#{endpoint}", json: params
        raise BadResponse, "#{response.status}\n#{response.body}" unless response.status.success?
        response
      end
      
      # Performs HTTP GET and cache it
      # Returns a parsed body on success
      # Raises BadResponse on error
      def post(endpoint, params = {})
        cache.get "#{root}/#{endpoint}+#{params}" do
          response = post! endpoint, params
          response.parse
        end
      end

      # Performs HTTP POST
      # Returns a parsed body on success
      # Raises BadResponse on error
      def post!(endpoint, params = {})
        response = HTTP.auth(auth_header).post "#{root}/#{endpoint}", json: params
        raise BadResponse, "#{response.status}\n#{response.body}" unless response.status.success?
        response
      end

      def cache
        @cache ||= Lightly.new life: cache_life, dir: cache_dir
      end

  protected

      def auth_header
        "Bearer #{key}"
      end

    end
  end
end

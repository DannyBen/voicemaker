require 'forwardable'

module Voicemaker
  # Provides easy and cached access to the list of available voices.
  class Voices
    extend Forwardable

    # Enable some of the hash methods idrectly on the Voices object
    def_delegators :all, :[], :count, :size, :first, :last, :select, :reject,
      :map, :keys, :values, :each

    # Returns all voices
    def all
      @all ||= begin
        response = API.get 'list'
        result = response.dig 'data', 'voices_list'
        raise BadResponse, "Unexpected response: #{response}" unless result

        result.map { |voice| [voice['VoiceId'], voice] }
          .sort_by { |_, v| v['VoiceId'] }.to_h
      end
    end

    # Returns a filtered list of voices, with all queries partially included
    # in the voice parameter values
    def search(*queries)
      queries = nil if queries&.empty?
      return all unless queries

      all.select do |_key, data|
        haystack = data.values.join(' ').downcase
        queries.all? { |query| haystack.include? query.downcase }
      end
    end

    # Returns a single voice, by Voice ID or Voice Webname
    def find(id_or_webname)
      all[id_or_webname] || all.find { |_, a| a['VoiceWebname'] == id_or_webname }&.last
    end
  end
end

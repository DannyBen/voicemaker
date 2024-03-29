require 'down'

module Voicemaker
  # Provides normalized access to all parameters needed for the TTS endpoint,
  # including the auto identification of the Engine and Language based on
  # voice ID, and including sensible defaults.
  class TTSParams
    attr_reader :input_params
    attr_writer :text, :voice, :output_format, :effect, :sample_rate,
      :master_speed, :master_volume, :master_pitch

    def initialize(input_params = {})
      @input_params = input_params
    end

    def inspect
      %[#<Voicemaker::TTSParams api_params="#{api_params}"]
    end

    def voice
      @voice ||= find_voice || raise(InputError, 'Missing or invalid parameter: voice')
    end

    def text
      @text ||= input_params[:text] || raise(InputError, 'Missing parameter: text')
    end

    def output_format
      @output_format ||= input_params[:output_format] || 'mp3'
    end

    def effect
      @effect ||= input_params[:effect] || 'default'
    end

    def sample_rate
      @sample_rate ||= (input_params[:sample_rate] || 48_000).to_s
    end

    def master_speed
      @master_speed ||= (input_params[:master_speed] || 0).to_s
    end

    def master_volume
      @master_volume ||= (input_params[:master_volume] || 0).to_s
    end

    def master_pitch
      @master_pitch ||= (input_params[:master_pitch] || 0).to_s
    end

    def api_params
      {
        'Engine'       => engine,
        'VoiceId'      => voice,
        'LanguageCode' => language,
        'OutputFormat' => output_format,
        'SampleRate'   => sample_rate,
        'Effect'       => effect,
        'MasterSpeed'  => master_speed,
        'MasterVolume' => master_volume,
        'MasterPitch'  => master_pitch,
        'Text'         => text,
      }
    end

  protected

    def engine
      voice_params['Engine']
    end

    def language
      voice_params['Language']
    end

    def find_voice
      return nil unless input_params[:voice]

      voices.find(input_params[:voice])&.dig 'VoiceId'
    end

    def voice_params
      voices[voice] || raise(InputError, "Cannot find definition for voice: #{voice}")
    end

    def voices
      @voices ||= Voices.new
    end
  end
end

module Voicemaker
  class VoicemakerError < StandardError; end
  class BadResponse < VoicemakerError; end
  class MissingAuth < VoicemakerError; end
  class InputError < VoicemakerError; end
end
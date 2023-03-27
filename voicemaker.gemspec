lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voicemaker/version'

Gem::Specification.new do |s|
  s.name        = 'voicemaker'
  s.version     = Voicemaker::VERSION
  s.summary     = 'Voicemaker.in Text to Speech API Library and Command Line'
  s.description = 'Easy to use API for Voicemaker.in TTS service, with a command line interface'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['voicemaker']
  s.homepage    = 'https://github.com/DannyBen/voicemaker'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'down', '~> 5.3'
  s.add_runtime_dependency 'http', '~> 5.0'
  s.add_runtime_dependency 'lightly', '~> 0.3'
  s.add_runtime_dependency 'lp', '~> 0.2'
  s.add_runtime_dependency 'mister_bin', '~> 0.7', '>= 0.7.6'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/voicemaker/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/voicemaker/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://github.com/DannyBen/voicemaker',
    'source_code_uri'       => 'https://github.com/DannyBen/voicemaker',
    'rubygems_mfa_required' => 'true',
  }
end

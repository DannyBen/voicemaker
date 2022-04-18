# Voicemaker API Library and Command Line

[![Gem Version](https://badge.fury.io/rb/voicemaker.svg)](https://badge.fury.io/rb/voicemaker)
[![Build Status](https://github.com/DannyBen/voicemaker/workflows/Test/badge.svg)](https://github.com/DannyBen/voicemaker/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/b1977ee0d60affeba3d4/maintainability)](https://codeclimate.com/github/DannyBen/voicemaker/maintainability)

---

This gem provides both a Ruby library and a command line interface for the 
[Voicemaker][voicemaker] Text to Speech service.

This gem is not affiliated with Voicemaker.

---


## Install

```
$ gem install voicemaker
```

## Features

- Use as a Ruby library or from the command line
- Show and search for available voices
- Convert text to MP3 or WAV from a simple configuration file
- Batch-convert multiple files


## Usage

### Initialization

First, require and initialize with your Voicemaker API key:

```ruby
require 'voicemaker'
api_key = '...'
api = Voicemaker::API.new api_key
```

### Voices list

Get the full voices list:

```ruby
result = api.voices
```

Search the voices list for one or more strings (AND search):

```ruby
result = api.voices ["en_US", "female"]
```

### Audio generation and download

Make an API call and get the URL to the audio file in return:

```ruby
result = api.generate Engine: "neural", VoiceId: "ai3-Jony",
  LanguageCode: "en-US", Text: "Hello world"
```

or with the full list of available parameters:

```ruby
params = {
  Engine: "neural",
  VoiceId: "ai3-Jony",
  LanguageCode: "en-US",
  Text: "Hello world",
  OutputFormat: "mp3",
  SampleRate: "48000",
  Effect: "default",
  MasterSpeed: "0",
  MasterVolume: "0",
  MasterPitch: "0",
}

result = api.generate params
```

For convenience, you can call `#download` instead, to mak ethe API call and
download the file:

```ruby
result = api.download "out.mp3', params
```

## Command line interface

<!-- USAGE -->
```
$ voicemaker --help

Voicemaker API

  API Documentation:
  https://developer.voicemaker.in/apidocs

Usage:
  voicemaker voices [--save PATH] [SEARCH...]
  voicemaker new CONFIG
  voicemaker generate CONFIG [OUTPUT]
  voicemaker batch INDIR OUTDIR
  voicemaker (-h|--help|--version)

Commands:
  voices
    Get list of voices, optionally in a given language

  new
    Generate a sample config file

  generate
    Generate audio file. The output filename will be the same as the config
    filename, with the proper mp3 or wav extension

  batch
    Generate multiple audio files from multiple config files

Options:
  -l --language LANG
    Limit results to a specific language

  -s --save PATH
    Save output to output YAML file

  -h --help
    Show this help

  --version
    Show version number

Parameters:
  SEARCH
    Provide one or more text strings to search for (case insensitive)

  CONFIG
    Path to config file

  OUTPUT
    Path to output mp3/wav file. If not provided, the filename will be the same
    as the config file, with wav/mp3 extension

  INDIR
    Path to input directory, containing config YAML files

  OURDIR
    Path to output directory, where mp3/wav files will be saved

Environment Variables:
  VOICEMAKER_API_KEY
    Your Voicemaker API key [required]

  VOICEMAKER_API_HOST
    Override the API host URL

Examples:
  voicemaker voices en-us
  voicemaker voices --save out.yml en-us
  voicemaker voices en-us female
  voicemaker new test.yml
  voicemaker generate test.yml out.mp3
  voicemaker batch configs out

```
<!-- USAGE -->


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].



[voicemaker]: https://voicemaker.in/
[issues]: https://github.com/DannyBen/voicemaker/issues

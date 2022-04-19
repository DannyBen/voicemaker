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
Voicemaker::API.key = 'your api key'
```

### Voices list

Get the full voices list:

```ruby
voices = Voicemaker::Voices.new
result = voices.all
```

Search the voices list for one or more strings (AND search):

```ruby
result = voices.search "en-us", "female"
```

### Audio generation and download

Make an API call and get the URL to the audio file in return:

```ruby
tts = Voicemaker::TTS.new voice: 'Jony', text: 'Hello world'
url = tts.url
tts.save "output.mp3"
```

or with the full list of available parameters:

```ruby
params = {
  voice: "Jony",
  output_format: "mp3",
  sample_rate: 48000,
  effect: "default",
  master_speed: 0,
  master_volume: 0,
  master_pitch: 0,
  text: "Hello world"
}

tts = Voicemaker::TTS.new params
url = tts.url
```

As the `voice` parameter, you may use either the voice ID (`ai3-Jony`) or the 
voice web name (`Jony`). Just note that some voices have the same webname (for
example, Emily), so in these cases it is best to use the full voice ID.

## Command line interface

<!-- USAGE -->
### `$ voicemaker `


```
Voicemaker Text-to-Speech

Commands:
  voices   Get a list of available voices
  tts      Generate audio files from text
  new      Create a new config file or a project directory
  project  Create multiple audio files

API Documentation: https://developer.voicemaker.in/apidocs

```

### `$ voicemaker voices --help`


```
Get a list of available voices

Usage:
  voicemaker voices [--save PATH --count --compact] [SEARCH...]
  voicemaker voices (-h|--help)

Options:
  -s --save PATH
    Save output to output YAML file

  -t --compact
    Show each voice in a single line

  -c --count
    Add number of voices to the result

  -h --help
    Show this help

Parameters:
  SEARCH
    Provide one or more text strings to search for (case insensitive AND search)

Environment Variables:
  VOICEMAKER_API_KEY
    Your Voicemaker API key [required]

  VOICEMAKER_API_HOST
    Override the API host URL

  VOICEMAKER_CACHE_DIR
    API cache diredctory [default: cache]

  VOICEMAKER_CACHE_LIFE
    API cache life. These formats are supported:
    off - No cache
    20s - 20 seconds
    10m - 10 minutes
    10h - 10 hours
    10d - 10 days

Examples:
  voicemaker voices en-us
  voicemaker voices --save out.yml en-us
  voicemaker voices en-us female
  voicemaker voices en-us --compact

```

### `$ voicemaker tts --help`


```
Generate audio files from text

Usage:
  voicemaker tts [options]
  voicemaker tts (-h|--help)

Options:
  -v --voice NAME
    Voice ID or Webname

  -t --text TEXT
    Text to say

  -f --file PATH
    Load text from file

  -c --config PATH
    Use a YAML configuration file

  -s --save PATH
    Save audio file.
    If not provided, a URL to the audio file will be printed instead.
    When used with the --config option, omit the file extension, as it will be
    determined based on the config file.

  -d --debug
    Show API parameters

  -h --help
    Show this help

Environment Variables:
  VOICEMAKER_API_KEY
    Your Voicemaker API key [required]

  VOICEMAKER_API_HOST
    Override the API host URL

  VOICEMAKER_CACHE_DIR
    API cache diredctory [default: cache]

  VOICEMAKER_CACHE_LIFE
    API cache life. These formats are supported:
    off - No cache
    20s - 20 seconds
    10m - 10 minutes
    10h - 10 hours
    10d - 10 days

Examples:
  voicemaker tts --voice ai3-Jony --text "Hello world" --save out.mp3
  voicemaker tts -v ai3-Jony --file hello.txt --save out.mp3
  voicemaker tts --config english-female.yml -f text.txt -s outfile

```

### `$ voicemaker new --help`


```
Create a new config file or a project directory

Usage:
  voicemaker new config PATH
  voicemaker new project DIR
  voicemaker new (-h|--help)

Commands:
  config
    Create a config file to be used with the 'voicemaker tts' command

  project
    Generate a project directory to be used with the 'voicemaker project'
    command

Options:
  -h --help
    Show this help

Parameters:
  PATH
    Path to use for creating the config file

  DIR
    Directory name for creating the project structure

Examples:
  voicemaker new config test.yml
  voicemaker new project sample-project

```

### `$ voicemaker project --help`


```
Create multiple audio files

Usage:
  voicemaker project PATH [--debug]
  voicemaker project (-h|--help)

Options:
  --debug
    Show API parameters

  -h --help
    Show this help

Parameters:
  PATH
    Path to the project directory

Environment Variables:
  VOICEMAKER_API_KEY
    Your Voicemaker API key [required]

  VOICEMAKER_API_HOST
    Override the API host URL

  VOICEMAKER_CACHE_DIR
    API cache diredctory [default: cache]

  VOICEMAKER_CACHE_LIFE
    API cache life. These formats are supported:
    off - No cache
    20s - 20 seconds
    10m - 10 minutes
    10h - 10 hours
    10d - 10 days

Examples:
  voicemaker project sample-project

```

<!-- USAGE -->


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].



[voicemaker]: https://voicemaker.in/
[issues]: https://github.com/DannyBen/voicemaker/issues

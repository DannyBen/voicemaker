require 'sinatra'
require 'byebug'
require 'yaml'
require 'json'

set :port, 3000
set :bind, '0.0.0.0'
set :server, :puma

def json(hash)
  content_type :json
  JSON.pretty_generate hash
end

def config
  @config ||= YAML.load_file(config_file)
end

def config_file
  File.expand_path 'config.yml', __dir__
end

get '/' do
  json mockserver: :online
end

# list voices
get '/list' do
  json config[:voices]
end

# generate audio
post '/api' do
  body = JSON.parse request.body.read
  if body['Text'] == 'ERROR ME'
    status 400
    json config[:generate_error]
  else
    json config[:generate]
  end
end

# download video
get '/uploads/:file' do
  content_type 'audio/mp3'
  send_file 'spec/mock_api/dummy.mp3', disposition: 'attachment', filename: params[:file]
end

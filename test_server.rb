require 'rubygems'
require 'sinatra'
require 'json'
require 'pry'

configure do
  set :logging, true
  set :dump_errors, true
  set :public_folder, -> { File.expand_path(File.join(root, 'LoopTests'))}
end

def render_fixture(filename)
  send_file File.join(settings.public_folder, filename)
end

post '/users' do
  content_type :json
  {user: {_id: '1234'}}.to_json
end

get '/' do
  render_fixture('user.json')
end

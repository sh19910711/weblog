require 'sinatra'
require 'logger'
require 'sinatra/reloader' if development?

$logger = Logger.new(STDOUT)

module Homepage
  class App < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      'hello'
    end

    get '/ping' do
      'pong'
    end
  end
end
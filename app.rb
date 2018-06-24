require 'sinatra'
require 'logger'
require 'sinatra/reloader' if development?

class App < Sinatra::Base
  attr_reader :logger

  configure :development do
    register Sinatra::Reloader
  end

  before do
    @logger = Logger.new(STDOUT)
  end

  get '/' do
    slim :index
  end
end

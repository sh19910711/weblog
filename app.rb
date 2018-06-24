require 'sinatra'
require 'logger'
require 'sinatra/reloader' if development?

require_relative 'lib/note'

$logger = Logger.new(STDOUT)

class App < Sinatra::Base
  configure :development do
    $logger.info('enable reloader')
    register Sinatra::Reloader
    Pathname.glob('lib/**/*.rb').each {|rb| also_reload rb }
  end

  before do
    @title = 'NO TITLE'
  end

  get '/' do
    slim :index
  end

  get '/notes/test' do
    @note = Note::Note.new('spec/fixtures/example_note.json')
    @title = "#{@note.name} - #{@title}"

    slim :notes
  end
end

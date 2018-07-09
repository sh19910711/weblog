require 'sinatra'
require 'logger'
require 'sinatra/reloader' if development?

require_relative '../lib/note'

$logger = Logger.new(STDOUT)

module HomePage
  class App < Sinatra::Base
    configure :development do
      $logger.info('enable reloader')
      register Sinatra::Reloader
      Pathname.glob('../lib/**/*.rb').each {|rb| also_reload rb }
    end

    before do
      @title = 'NO TITLE '
    end

    get '/' do
      @notes = Note::Note.all if Note::Note.count

      slim :index
    end

    get '/notes/:id' do
      @note = Note::Note.find(params[:id])
      @note.fetch
      @title = "#{@note.name} - #{@title}"

      slim :notes_show
    end

    get '/ping' do
      'pong'
    end
  end
end

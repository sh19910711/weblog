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
      Pathname.glob('lib/**/*.rb').each {|rb| also_reload rb }
    end

    before do
      @site_name = 'NO TITLE'
      @title = @site_name
    end

    helpers do
      def og_meta
        if n = @note
          <<-HTML
            <meta property="og:title" content="#{escape_html @title}" />
            <meta property="og:type" content="article" />
            <meta property="og:url" content="https://hiroyuki.sano.ninja/notes/#{n.id}" />
            <meta property="og:image" content="#{n.image}" />
            <meta property="og:description" content="#{escape_html n.summary}" />
            <meta property="og:site_name" content="#{@site_name}" />
          HTML
        end
      end
    end

    get '/' do
      q = Note::Note.where(is_public: true)

      @notes = q.all if Note::Note.count > 0

      slim :index
    end

    get '/notes/:id' do
      @note = Note::Note.find(params[:id])
      @note.fetch

      @title = "#{@note.subject} - #{@title}"

      slim :notes_show
    end

    get '/ping' do
      'pong'
    end
  end
end

libdir = File.join(File.dirname(__FILE__), '../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'database'
require 'model'
require 'content'
require 'storage'

require 'sinatra'
require 'logger'
require 'sinatra/reloader' if development?

$logger = Logger.new(STDOUT)

module Homepage
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
      def development?
        ENV['RACK_ENV'] == 'development'
      end

      def og_meta
        if n = @note
          <<-HTML
            <meta property="og:title" content="#{escape_html @title}" />
            <meta property="og:type" content="article" />
            <meta property="og:url" content="https://hiroyuki.sano.ninja/notes/#{n.note_id}" />
            <meta property="og:image" content="#{n.image}" />
            <meta property="og:description" content="#{escape_html n.content.summary}" />
            <meta property="og:site_name" content="#{@site_name}" />
          HTML
        end
      end

      def aggregated_tags
        es = Storage::Elasticsearch.new
        aggregates_params = {
          'all_tags': {
            'terms': {
              'field': 'tag'
            }
          }
        }
        res = es.search('note_tags', {'aggs': aggregates_params})
        res['aggregations']['all_tags']['buckets']
      end
    end

    get '/' do
      q = Model::Note.where(is_public: 't')
      q = q.or(Model::Note.where(is_public: 'f')) if development?
      @notes = q.order('created_at desc').all

      slim :index
    end

    get '/notes/:id' do
      @note = Model::Note.find_by(note_id: params[:id])
      @note.read_content!
      @title = "#{@note.subject} - #{@title}"

      slim :notes_show
    end

    get '/tags/:key' do
      es = Storage::Elasticsearch.new
      query_params = {
        match: {
          tag: params[:key]
        }
      }
      res = es.search('note_tags', {'query': query_params})
      note_ids = res['hits']['hits'].map{|hit| hit['_source']['note_id'] }

      @notes = Model::Note.where(note_id: note_ids).order('created_at desc')

      slim :index
    end

    get '/ping' do
      'pong'
    end
  end
end

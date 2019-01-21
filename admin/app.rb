libdir = File.join(File.dirname(__FILE__), '../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'database'
require 'model'
require 'content'
require 'storage'

require 'sinatra'
require 'sinatra/reloader'
require 'byebug'

module Admin
  class App < Sinatra::Base
    enable :prefixed_redirects

    configure :development do
      $logger.info('enable reloader')
      register Sinatra::Reloader
      Pathname.glob('lib/**/*.rb').each {|rb| also_reload rb }
    end

    helpers do
      def param_id
        params['note.id'].strip
      end

      def param_path
        params['note.path'].strip
      end

      def param_is_public
        params['note.is_public'].strip == "true"
      end

      def param_is_development
        params['note.is_development'].strip == "true"
      end

      def param_image
        params['note.image'].strip
      end
    end

    get '/' do
      s3 = Aws::S3::Resource.new
      keys = s3.bucket(ENV['S3_BUCKET']).objects(prefix: ENV['S3_PREFIX']).map(&:key)
      @objects = keys.map do |k|
        { url: "s3://#{ENV['S3_BUCKET']}/#{k}" }
      end

      @notes = Model::Note.where(is_public: true).order("created_at desc")
      @drafts = Model::Note.where(is_public: false).order("created_at desc")

      slim :admin
    end

    get '/edit/:note_id' do
      @model = Model::Note.find_by(note_id: params[:note_id])
      @model.read_content!

      slim :edit_note
    end

    post '/edit/add_tag' do
      @model = Model::Note.find_by(note_id: params[:note_id])
      @model.add_tag(params[:tag])

      redirect "/edit/#{params[:note_id]}"
    end

    post '/edit/delete_tag' do
      @model = Model::Note.find_by(note_id: params[:note_id])
      @model.delete_tag(params[:tag])

      redirect "/edit/#{params[:note_id]}"
    end
  end
end

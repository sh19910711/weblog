require 'sinatra'
require 'sinatra/reloader'
require_relative '../lib/note'
require 'aws-sdk'
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
        if v = params['note.is_public']
          v.strip == "true"
        end
      end

      def param_image
        params['note.image'].strip
      end
    end

    get '/' do
      s3 = Aws::S3::Resource.new
      keys = s3.bucket(ENV['S3_BUCKET']).objects(prefix: ENV['S3_PREFIX']).map(&:key)
      @objects = keys.map {|k| "s3://#{ENV['S3_BUCKET']}/#{k}" }

      @notes = if Note::Note.all.count > 0
        Note::Note.all.reduce(Hash.new) {|o, n| o[n.path] = n; o }
      else
        Hash.new
      end

      slim :admin
    end

    post '/preview' do
      q = Note::Note.where(path: path)

      @note = if q.count > 0
        q.first
      else
        Note::Note.new(path: path)
      end

      @note.fetch

      slim :preview
    end

    post '/save' do
      if note = Note::Note.find(param_id)
        note.image = param_image
        note.is_public = param_is_public
        note.save
      end

      redirect '/'
    end

    get '/notes/:id' do
      @note = Note::Note.find(params[:id])

      slim :note
    end

    post '/notes/:id/delete' do
      @note = Note::Note.find(params[:id])
      @note.delete

      redirect '/'
    end
  end
end

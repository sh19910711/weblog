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
      Note::Note.create_table
    end

    helpers do
      def path
        params[:path].strip
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
      @note = Note::Note.new(path: path)
      @note.fetch

      slim :preview
    end

    post '/objects' do
      q = Note::Note.where(path: path)

      m = if q.count > 0
        q.first
      else
        Note::Note.new(path: path)
      end

      m.fetch
      m.save

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

libdir = File.join(File.dirname(__FILE__), '../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'database'
require 'model'
require 'content'
require 'storage'

require 'sinatra'
require 'sinatra/reloader'
require 'byebug'

def import_zeppelin
  s3 = Aws::S3::Resource.new
  keys = s3.bucket(ENV['S3_BUCKET']).objects(prefix: ENV['S3_PREFIX']).map(&:key)
  urls = keys.map do |k|
    "s3://#{ENV['S3_BUCKET']}/#{k}"
  end

  Model::Note.where(url: urls).each do |note|
    urls.delete(note.url)
  end

  Model::Note.transaction do
    urls.each do |url|
      puts "import: #{url}"
      Model::Note.import_zeppelin(url)
    end
  end
end

module Admin
  class App < Sinatra::Base
    enable :prefixed_redirects

    configure :development do
      register Sinatra::Reloader
      Pathname.glob('lib/**/*.rb').each {|rb| also_reload rb }
    end

    get '/' do
      @notes = Model::Note.where(is_public: true).order("created_at desc")
      @drafts = Model::Note.where(is_public: false).order("created_at desc")

      slim :admin
    end

    get '/edit/:note_id' do
      @model = Model::Note.find_by(note_id: params[:note_id])
      @model.read_content!
      @model.image ||= 'https://static.sano.ninja/img/image_icon.png'

      slim :edit_note
    end

    post '/edit/update' do
      @model = Model::Note.find(params[:note_id])
      @model.image = params['image']
      @model.is_public = params['is_public'].strip == 'true'
      @model.save

      redirect '/'
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

    post '/import_zeppelin' do
      import_zeppelin

      redirect "/"
    end
  end
end

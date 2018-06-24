require 'sinatra'
require 'sinatra/reloader'
require_relative '../lib/note'
require 'aws-sdk'
require 'byebug'

module Admin
  class App < Sinatra::Base
    configure do
      register Sinatra::Reloader
      Pathname.glob('../lib/**/*.rb').each {|rb| also_reload rb }
    end

    get '/objects' do
      s3 = Aws::S3::Resource.new
      s3.bucket(ENV['S3_BUCKET']).objects(prefix: ENV['S3_PREFIX']).map(&:key)
    end

    get '/notes' do
      @notes = Note::Note.all

      slim :notes
    end
  end
end

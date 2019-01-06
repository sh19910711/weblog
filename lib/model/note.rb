require 'storage'

module Model
  class Note < ActiveRecord::Base
    attr_reader :content

    def read_content!
      if note_type == 'zeppelin'
        s3 = Storage::S3.new
        @content = JSON.parse(s3.read_object(url))
      end

      update(name: content['name']) if name != content['name']
    end

    def subject
      name.gsub(/\//, ' / ')
    end

    def date
      created_at.strftime('%Y/%m/%d')
    end
  end
end

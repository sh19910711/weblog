require 'storage'
require 'content'

module Model
  class Note < ActiveRecord::Base
    attr_reader :content

    def read_content!
      if note_type == 'zeppelin'
        s3 = Storage::S3.new
        @content = Content::Zeppelin::Reader.new(s3.read_object(url))
      end

      update(name: content.name) if name != content.name
    end

    def subject
      name.gsub(/\//, ' / ')
    end

    def date
      created_at.strftime('%Y/%m/%d')
    end

    def tags
      es = Storage::Elasticsearch.new
      query_params = {
        match: {
          note_id: note_id
        }
      }
      sort_params = {
        tag: {
          order: 'asc'
        }
      }
      res = es.search('note_tags', {query: query_params, sort: sort_params})
      res['hits']['hits'].map {|hit| hit['_source']['tag'] }
    end
  end
end

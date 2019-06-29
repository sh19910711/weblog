require 'storage'
require 'content'
require 'securerandom'

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
      name.split('/').reverse.join(' / ')
    end

    def date
      updated_at.strftime('%Y/%m/%d')
    end

    def tags
      es = Storage::Elasticsearch.new
      query = {
        match: {
          note_id: note_id
        }
      }
      sort_params = {
        tag: {
          order: 'asc'
        }
      }
      aggs = {
        tags: {
          terms: { field: 'tag' },
        }
      }
      res = es.search('homepage_note_tags', {query: query, sort: sort_params, aggs: aggs})
      res['aggregations']['tags']['buckets'].map {|b| b['key'] }
    end

    def add_tag(tag_name)
      es = Storage::Elasticsearch.new
      es.index('homepage_note_tags', {
        note_id: note_id,
        tag: tag_name.strip,
      })
    end

    def delete_tag(tag_name)
      es = Storage::Elasticsearch.new
      query_params = {
        bool: {
          must: [
            {
              match: {
                note_id: note_id,
              }
            },
            {
              match: {
                tag: tag_name.strip,
              }
            },
          ]
        }
      }
      res = es.search('homepage_note_tags', {query: query_params})

      res['hits']['hits'].each do |hit|
        es.delete('homepage_note_tags', hit['_id'])
      end
    end

    class << self
      def import_zeppelin(url)
        note = self.new(
          note_id: SecureRandom.uuid,
          note_type: 'zeppelin',
          url: url,
          is_public: false
        )
        note.read_content!
        note.save
      end
    end
  end
end

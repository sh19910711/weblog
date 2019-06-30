libdir = File.join(File.dirname(__FILE__), './homepagelib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
puts 'require ok'

ENV['DATABASE_HOST'] = 'database.homepage2'
ENV['DATABASE_USERNAME'] = 'root'
ENV['DATABASE_PASSWORD'] = 'mysql'
ENV['SEARCH_HOST'] = 'search.homepage2'

require 'database'
require 'model'
require 'storage'

puts 'second require ok'

def handler(event:, context:)
  puts 'handler: start'
  p event
  case event['type']
  when 'ping'
    'pong'
  when 'all'
    Model::Note.all.to_json
  when 'query'
    res = ActiveRecord::Base.connection.execute(event['sql'])
    res.to_a(:as => :hash).to_json if res
  when 'search:bulk'
    es = Storage::Elasticsearch.new
    es.client.bulk(body: JSON.parse(event['body']))
  when 'search:search'
    es = Storage::Elasticsearch.new
    es.client.search(JSON.parse(event['params'], symbolize_names: true))
  when 'search:delete_by_query'
    es = Storage::Elasticsearch.new
    es.client.delete_by_query(JSON.parse(event['params'], symbolize_names: true))
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  Class.new(Minitest::Test) do
    def test_search_bulk
      body = []
      body << {index: {_index: 'homepage_note_tags', data: {note_id: '4ba462da-f8f7-4a5a-8366-37e2762eb784', tag: '*algorithm7'}}}
      body << {index: {_index: 'homepage_note_tags', data: {note_id: '4ba462da-f8f7-4a5a-8366-37e2762eb784', tag: '*algorithm8'}}}
      body << {index: {_index: 'homepage_note_tags', data: {note_id: '4ba462da-f8f7-4a5a-8366-37e2762eb784', tag: '*algorithm9'}}}
      puts handler(
        event: JSON.parse({
          'type': 'search:bulk',
          'body': body.to_json
        }.to_json),
        context: nil
      )
    end

    def test_search_search
      event = {
        type: 'search:search',
        params: {
          index: 'homepage_note_tags',
        }.to_json,
      }
      res = handler(event: JSON.parse(event.to_json), context: nil)
      assert_includes res['hits']['hits'].map { |h| h['_source']['tag'] }, 'Python'
    end

    def test_search_delete_by_query
      es = Storage::Elasticsearch.new
      es.client.index(index: 'test_docs', body: {tag: 'Python'})
      es.client.index(index: 'test_docs', body: {tag: 'AOJ'})
      es.client.indices.refresh(index: 'test_docs')

      event = {
        type: 'search:delete_by_query',
        params: {
          index: 'test_docs',
          body: {
            query: {
              match: {
                tag: 'AOJ'
              }
            }
          }
        }.to_json,
      }
      handler(event: JSON.parse(event.to_json), context: nil)
      es.client.indices.refresh(index: 'test_docs')

      event = {
        type: 'search:search',
        params: {
          index: 'test_docs',
        }.to_json,
      }
      res = handler(event: JSON.parse(event.to_json), context: nil)
      assert res['hits']['hits'].map { |h| h['_source']['tag'] }.include?('Python'), 'Python should be included.'
      assert !res['hits']['hits'].map { |h| h['_source']['tag'] }.include?('AOJ'), 'AOJ should not be included.'
    end
  end
end

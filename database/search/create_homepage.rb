require 'storage/elasticsearch'

es = Storage::Elasticsearch.new
es.client.indices.delete(index: 'homepage_note_tags')
es.client.indices.create(index: 'homepage_note_tags')
es.client.indices.put_mapping(index: 'homepage_note_tags', body: {
  properties: {
    note_id: {
      type: "keyword"
    },
    tag: {
      type: "keyword"
    }
  }
})

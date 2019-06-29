require 'storage/elasticsearch'

es = Storage::Elasticsearch.new
es.client.indices.create(index: 'homepage')
es.client.indices.put_mapping(index: 'homepage', type: 'note_tags', body: {
  note_tags: {
    properties: {
      note_id: {
        type: "keyword",
        index: true
      },
      "tag": {
        type: "keyword",
        index: true
      }
    }
	}
})

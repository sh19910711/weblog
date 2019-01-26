require 'elasticsearch'

module Storage
  class Elasticsearch
    attr_reader :client
    attr_reader :index

    def initialize
      # TODO: stop hard coding
      @client = ::Elasticsearch::Client.new(url: "http://#{ENV['SEARCH_HOST']}:9200", log: true)
      @index = 'homepage'
    end

    def search(type, body)
      client.search(index: 'homepage', type: type, body: body)
    end

    def index(type, body)
      client.index(index: 'homepage', type: type, body: body)
    end

    def delete(type, doc_id)
      client.delete(index: 'homepage', type: type, id: doc_id)
    end
  end
end

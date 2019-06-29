require 'elasticsearch'

module Storage
  class Elasticsearch
    attr_reader :client
    attr_reader :index

    def initialize
      # TODO: stop hard coding
      @client = ::Elasticsearch::Client.new(url: "http://#{ENV['SEARCH_HOST']}:#{ENV['SEARCH_PORT'] || 9200}", log: true)
      @index = 'homepage'
    end

    def search(index, body)
      client.search(index: index, body: body)
    end

    def index(index, body)
      client.index(index: index, body: body)
    end

    def delete(index, doc_id)
      client.delete(index: index, id: doc_id)
    end
  end
end

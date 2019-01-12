require 'elasticsearch'

module Storage
  class Elasticsearch
    attr_reader :client

    def initialize
      @client = ::Elasticsearch::Client.new(url: 'http://search:9200', log: true)
    end

    def search(type, body)
      client.search(index: 'homepage', type: type, body: body)
    end
  end
end

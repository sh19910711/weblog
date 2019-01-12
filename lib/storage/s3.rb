require 'aws-sdk-s3'
require 'uri'

module Storage
  class S3
    attr_reader :client

    def initialize(*args)
      @client = Aws::S3::Client.new(*args)
    end

    def read_object(url)
      u = URI.parse(url)
      o = client.get_object(bucket: u.host, key: u.path[1..-1])
      o.body.read
    end
  end
end

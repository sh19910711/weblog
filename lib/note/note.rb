require 'aws-sdk'
require 'dynamoid'
require 'json'
require 'uri'

module Note
  class Note
    include Dynamoid::Document

    table(
      :name => :notes,
      :id => :id,
      :read_capacity => 1,
      :write_capacity => 1,
    )

    field :path, :string
    field :name, :string

    def content
      @content ||= if %r{^s3://} === path
        JSON.parse(s3_content)
      else
        JSON.parse(File.read(path))
      end
    end

    def fetch
      id = content['id']
      self.name = content['name']
    end

    def paragraphs
      content['paragraphs'].map {|p| Paragraph.new(p) }.select(&:finished?)
    end

    private

      def s3_content
        c = Aws::S3::Client.new
        u = URI.parse(path)
        res = c.get_object(bucket: u.host, key: u.path[1..-1]).body.read
      end
  end
end

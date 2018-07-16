require 'aws-sdk'
require 'dynamoid'
require 'json'
require 'uri'

module Note
  class Note
    include Dynamoid::Document

    table(
      :name => :notes,
      :key => :id,
      :read_capacity => 1,
      :write_capacity => 1,
    )

    field :note_id, :string
    field :path, :string
    field :name, :string
    global_secondary_index(
      hash_key: :note_id,
      range_key: :note_id,
    )

    def subject
      name.gsub(/\//, ' / ')
    end

    def date
      if p = paragraphs.first
        Date.parse(p.content['dateCreated']).strftime('%Y/%m/%d')
      end
    end

    def content
      @content ||= if %r{^s3://} === path
        JSON.parse(s3_content)
      else
        JSON.parse(File.read(path))
      end
    end

    def fetch
      self.note_id = content['id']
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

require 'aws-sdk'
require 'dynamoid'
require 'json'
require 'uri'

module Note
  class Note
		include Dynamoid::Document

		table(
			:name => :notes,
			:key => :path,
			:read_capacity => 1,
			:write_capacity => 1,
		)

    def content
      @content ||= JSON.parse(s3_content)
    end

    def name
      content['name']
    end

    def paragraphs
      content['paragraphs'].map {|p| Paragraph.new(p) }.select(&:finished?)
    end

    private

      def s3_content
        c = Aws::S3::Client.new
        u = URI.parse(self.path)
        res = c.get_object(bucket: u.host, key: u.path[1..-1]).body.read
      end
  end
end

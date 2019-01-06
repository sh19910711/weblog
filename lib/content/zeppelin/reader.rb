require 'json'

module Content
  module Zeppelin
    class Reader
			attr_reader :content

      def initialize(body)
        @content = JSON.parse(body)
      end

      def summary
        if p = paragraphs.first
          p.text.gsub(/^%.*\s/, '').gsub(/\\\\[\(\)]/, '')
        end
      end

      def paragraphs
        content['paragraphs'].map {|p| Paragraph.new(p) }.select(&:finished?)
      end
    end
  end
end

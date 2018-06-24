require 'json'

module Note
  class Note
    attr_reader :content

    def initialize(filepath)
      @content = JSON.parse(File.read(filepath))
    end

    def name
      content['name']
    end

    def paragraphs
      content['paragraphs'].map {|p| Paragraph.new(p) }.select(&:finished?)
    end
  end
end

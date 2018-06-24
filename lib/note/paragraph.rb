module Note
  class Paragraph
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def text
      @content['text']
    end

    def results
      if res = @content['results']
        @content['results']['msg'].map{|m|m['data']}.join('\n')
      end
    end
  end
end

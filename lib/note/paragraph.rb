module Note
  class Paragraph
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def text
      content['text']
    end

    def results
      if res = content['results']
        s = Struct.new(:type, :data)
        content['results']['msg'].map{|m| s.new(m['type'], m['data'].gsub(/<div>$/, '</div>')) }
      else
        Array.new
      end
    end

    def date_started
      content['dateStarted']
    end

    def date_finished
      content['dateFinished']
    end

    def date_updated
      content['dateUpdated']
    end

    def finished?
      content['status'] == 'FINISHED'
    end

    def editor_hidden?
      ['ace/mode/markdown'].include?(editor_mode)
    end

    def editor_mode
      content['config']['editorMode']
    end

    def id
      content['id']
    end
  end
end

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
        content['results']['msg'].map{|m|m['data']}.join('\n')
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

    def editor_mode
      content['editorMode']
    end

    def id
      content['id']
    end
  end
end

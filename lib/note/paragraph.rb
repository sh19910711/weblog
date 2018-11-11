module Note
  class Paragraph
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def title
      content['title']
    end

    def text
      content['text']
    end

    def results
      if content['results']
        s = Struct.new(:type, :data, :config)
        content['results']['msg'].map.with_index do |m, i|
          c = content['config']['results'][i.to_s]

          if c && c['graph']
            s.new('GRAPH', m['data'], c['graph'])
          else
            s.new(m['type'], m['data'].gsub(/<div>$/, '</div>'))
          end
        end
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
      content['config']['editorHide']
    end

    def editor_mode
      content['config']['editorMode']
    end

    def id
      content['id']
    end
  end
end

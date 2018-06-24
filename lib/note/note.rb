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
  end
end

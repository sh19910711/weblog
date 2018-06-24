require 'json'

class Note
  attr_reader :content

  def initialize(filepath)
    @content = JSON.parse(File.read(File.expand_path(filepath)))
  end

  def name
    content['name']
  end
end

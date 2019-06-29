libdir = File.join(File.dirname(__FILE__), './homepagelib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
puts 'require ok'

ENV['DATABASE_HOST'] = 'database.homepage2' # host
ENV['DATABASE_PORT'] = '3306' # port
ENV['DATABASE_USERNAME'] = 'root'
ENV['DATABASE_PASSWORD'] = 'mysql'

require 'database'
require 'model'
# require 'content'
# require 'storage'

puts 'second require ok'

def handler(event:, context:)
  puts 'handler: start'
  p event
  case event['type']
  when 'all'
    Model::Note.all.to_json
  when 'query'
    res = ActiveRecord::Base.connection.execute(event['sql'])
    res.to_a(:as => :hash).to_json if res
  end
end

if __FILE__ == $0
  puts handler(
    event: JSON.parse({
      'type': 'query',
      'sql': 'select * from notes'
    }.to_json),
    context: nil
  )
end

require 'logger'
require_relative 'homepage/app'

logger = Logger.new(STDOUT)
def logger.write(msg)
end
use Rack::CommonLogger, logger

run HomePage::App

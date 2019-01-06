SPEC_ROOT = Pathname.new(File.expand_path(File.join(__FILE__, '..')))

require 'active_record'
require 'yaml'
db_config = YAML.load(File.open(SPEC_ROOT + '../database/config.yml'))
ActiveRecord::Base.establish_connection(db_config)

require 'content'
require 'storage'
require 'model'
require_relative '../homepage/app'

require 'rack/test'

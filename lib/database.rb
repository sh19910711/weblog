require 'pathname'
require 'active_record'
require 'yaml'
require 'erb'

ROOT = Pathname.new(File.expand_path(File.join(__FILE__, '..')))
db_config = YAML.load(ERB.new(File.read(ROOT + '../database/config.yml.erb')).result)
ActiveRecord::Base.establish_connection(db_config)

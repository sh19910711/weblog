SPEC_ROOT = Pathname.new(File.expand_path(File.join(__FILE__, '..')))

require 'database'
require 'content'
require 'storage'
require 'model'
require_relative '../homepage/app'
require 'rack/test'

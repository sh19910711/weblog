require 'content'
require 'storage'
require_relative '../homepage/app'

require 'rack/test'

SPEC_ROOT = Pathname.new(File.expand_path(File.join(__FILE__, '..')))

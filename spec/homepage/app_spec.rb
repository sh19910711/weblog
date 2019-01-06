require 'spec_helper'

describe Homepage::App do
  include Rack::Test::Methods

  def app
    Homepage::App
  end

  example {}
end

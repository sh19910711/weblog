require_relative '../homepage/app'
require_relative '../admin/app'

map '/' do
  run Homepage::App
end

map '/admin' do
  run Admin::App
end

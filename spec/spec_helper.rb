ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'application')
require File.join(File.dirname(__FILE__), '..', 'lib', 'eptica_api')
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

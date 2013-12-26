ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'application')
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

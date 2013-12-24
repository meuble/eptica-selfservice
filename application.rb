require 'rubygems'
require 'sinatra'
require 'awesome_print'

set :haml, :format => :html5

get '/' do
  haml :index
end
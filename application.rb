require 'rubygems'
require 'sinatra'
require 'awesome_print'

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/data' do
  callback = params.delete('callback')
  pattern = params.delete('pattern')
  json = "{'response':['réponse 1 : #{pattern}', 'réponse 2 : #{pattern}', 'réponse 3 : #{pattern}', 'réponse 4 : #{pattern}']}"

  content_type :js
  response = "#{callback}(#{json})"
end
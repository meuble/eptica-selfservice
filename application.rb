require 'rubygems'
require 'sinatra'
require 'awesome_print'

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/data' do
  callback = params.delete('callback') || 'callback'
  pattern = params.delete('pattern')
  eapi = EpticaAPI.new

  begin
    data = eapi.configurations('sport7').document_groups(21).search(pattern).fetch
    json = {:response => data}.to_json
  rescue EpticaAPI::APIError => e
    json = {:error => e.message}.to_json
  end

  content_type :js
  response = "#{callback}(#{json})"
end
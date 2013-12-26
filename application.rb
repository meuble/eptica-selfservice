require 'rubygems'
require 'sinatra'
require 'awesome_print'
require 'haml'
require File.join(File.dirname(__FILE__), 'lib', 'eptica_api')

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/data' do
  callback = params.delete('callback') || 'callback'
  pattern = params.delete('pattern')

  begin
    data = EpticaAPI.new.configurations('sport7').document_groups(21).search(pattern).fetch
    data = data.map {|d| EpticaAPI.new.configurations('sport7').document(d['document']['id']).fetch}
    json = {:response => data}.to_json
    status = 200
  rescue EpticaAPI::APIError => e
    json = {:error => e.message}.to_json
    status = 404
  end

  content_type :js
  response = "#{callback}(#{json})"
end

get "/documents/:id" do
  eapi = EpticaAPI.new
  @document = eapi.configurations('sport7').document(params[:id]).fetch
  @content = eapi.content.fetch
  haml :documents
end
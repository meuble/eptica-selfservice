require 'httparty'
require 'json'

class EpticaAPI
  class APIError < Exception; end
  include HTTParty

  def initialize
    self.class.base_uri "http://demo.eptica.com/selfdemoavv/api/"
    @configurations = ''
    @document_groups = ''
    @offset = 0
    @page_size = 10
  end

  def configurations(id = nil)
    @configurations = '/configuration'
    @configurations += "/#{id}" if id
    self
  end

  def document_groups(id)
    @document_groups = "/documentGroup/#{id}"
    self
  end

  def search(query)
    @search = "/search"
    @query = query
  end

  def offset(value = 0)
    @offset = value
  end

  def page_size(value = 10)
    @page_size = value
  end

  def path
    "#{@configurations}#{@document_groups}#{@search}"
  end

  def options
    {:offset => @offset, :pageSize => @page_size, :query => @query}
  end

  def fetch
    r = self.class.get(self.path, self.options)
    r = JSON.parse(r)
    if r["code"]
      raise APIError.new("#{r["code"]}(#{r["status"]}): #{r["message"]}")
    end
    r['elements']
  end
end
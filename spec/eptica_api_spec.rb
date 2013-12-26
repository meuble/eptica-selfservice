#encoding: utf-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe EpticaAPI do
  describe "initialise" do
    it 'should set base_url to eptica demo' do
      eapi = EpticaAPI.new
      eapi.class.base_uri.should == "http://demo.eptica.com/selfdemoavv/api"
    end
  end

  describe "#configurations" do
    it 'should build a path for all configurations' do
      eapi = EpticaAPI.new
      eapi.configurations
      eapi.path.should == "/configuration"
    end

    it 'should build a path for the given configurations' do
      eapi = EpticaAPI.new
      eapi.configurations('sport')
      eapi.path.should == "/configuration/sport"
    end

    it 'should return self to be chainable' do
      eapi = EpticaAPI.new
      r = eapi.configurations('sport')
      r.should == eapi
    end
  end
  
  describe "#document_groups" do
    it 'should build a path for the given document group' do
      eapi = EpticaAPI.new
      eapi.document_groups(21)
      eapi.path.should == "/documentGroup/21"
    end

    it 'should require an id' do
      eapi = EpticaAPI.new
      lambda do
        eapi.document_groups()
      end.should raise_error
    end

    it 'should return self to be chainable' do
      eapi = EpticaAPI.new
      r = eapi.document_groups(21)
      r.should == eapi
    end
  end

  describe "#offset" do
    it 'should build option for the given offset' do
      eapi = EpticaAPI.new
      eapi.offset(42)
      eapi.options[:offset].should == 42
    end

    it 'should default to 0' do
      eapi = EpticaAPI.new
      eapi.offset
      eapi.options[:offset].should == 0
    end
  end

  describe "#page_size" do
    it 'should build option for the given offset' do
      eapi = EpticaAPI.new
      eapi.page_size(42)
      eapi.options[:pageSize].should == 42
    end

    it 'should default to 10' do
      eapi = EpticaAPI.new
      eapi.page_size
      eapi.options[:pageSize].should == 10
    end
  end

  describe "#path" do
    it 'should build path from configuration and document group' do
      eapi = EpticaAPI.new
      eapi.document_groups(21)
      eapi.configurations("tennis")
      eapi.path.should == "/configuration/tennis/documentGroup/21"
    end
  end

  describe "#options" do
    it 'should build options from offset, page_size and query' do
      eapi = EpticaAPI.new
      eapi.page_size(42)
      eapi.offset(42)
      eapi.options.should == {:offset => 42, :pageSize => 42, :query => nil}
    end
  end

  describe "#fetch" do
    it 'should get from base_uri' do
      EpticaAPI.should_receive(:get).with('/configuration', {:offset => 0, :pageSize => 10, :query => nil}).and_return('{}')
      eapi = EpticaAPI.new
      r = eapi.configurations.fetch
    end

    it "should parse json and return elements" do
      EpticaAPI.should_receive(:get).with('/configuration', {:offset => 0, :pageSize => 10, :query => nil}).and_return('{"pager":{"offset":0,"pageSize":10},"elements":[{"id":"brand1","uri":"/selfdemoavv/api/configuration/brand1"},{"id":"securitasdirect","uri":"/selfdemoavv/api/configuration/securitasdirect"},{"id":"selfdemoavv","uri":"/selfdemoavv/api/configuration/selfdemoavv"},{"id":"sport7","uri":"/selfdemoavv/api/configuration/sport7"}]}')
      eapi = EpticaAPI.new
      r = eapi.configurations.fetch
      r.should == [{"id" => "brand1","uri" => "/selfdemoavv/api/configuration/brand1"},
        {"id" => "securitasdirect","uri" => "/selfdemoavv/api/configuration/securitasdirect"},
        {"id" => "selfdemoavv","uri" => "/selfdemoavv/api/configuration/selfdemoavv"},
        {"id" => "sport7","uri" => "/selfdemoavv/api/configuration/sport7"}]
    end
    
    it "should raise if api error" do
      EpticaAPI.should_receive(:get).with('/configuration', {:offset => 0, :pageSize => 10, :query => nil}).and_return('{ "status" : 404, "code" : "EPTICA_ERR_RESOURCE_NOT_FOUND", "message" : "There is no resource for path : /selfdemoavv/api/configurations/" }')
      eapi = EpticaAPI.new
      lambda do
        r = eapi.configurations.fetch
      end.should raise_error(EpticaAPI::APIError)
    end
  end
end
#encoding: utf-8

require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'The Eptica SelfService Demo App' do
  def app
    Sinatra::Application
  end

  describe '#index' do
    it "should respond ok" do
      get '/'
      expect(last_response).to be_ok
    end

    it "should display a search input" do
      get '/'
      last_response.body.include?("<input id='pattern' name='pattern' type='text'>").should be_true
    end
  end

  describe '#data' do
    it 'should render contente type as js' do
      fake_search = double()
      fake_search.should_receive(:fetch).and_return([])
      fake_api = double(:configurations => double(:document_groups => double(:search => fake_search)))
      EpticaAPI.stub(:new).and_return(fake_api)

      get '/data'
      last_response.header['Content-Type'].include?('application/javascript').should be_true
    end

    describe 'with pattern' do
      it 'should return results' do
        pattern = "pattern"
        data = [{"document" => 
            {"id" => "56","uri" => "/selfdemoavv/api/configuration/sport7/document/56"},"relevance" => 41.0},
          {"document" => 
            {"id" => "57","uri" => "/selfdemoavv/api/configuration/sport7/document/57"},"relevance" => 38.0},
          {"document" => 
            {"id" => "65","uri" => "/selfdemoavv/api/configuration/sport7/document/65"},"relevance" => 36.0},
          {"document" => 
            {"id" => "64","uri" => "/selfdemoavv/api/configuration/sport7/document/64"},"relevance" => 36.0}]

        fake_search = double()
        fake_search.should_receive(:fetch).and_return(data)
        fake_api = double(:configurations => double(:document_groups => double(:search => fake_search)))
        EpticaAPI.stub(:new).and_return(fake_api)

        get '/data', {:pattern => pattern}
        last_response.body.should == "callback(#{{:response => data}.to_json})"
      end
    end

    describe 'without pattern' do
      it 'should return empty array as response' do
        fake_search = double()
        fake_search.should_receive(:fetch).and_return([])
        fake_api = double(:configurations => double(:document_groups => double(:search => fake_search)))
        EpticaAPI.stub(:new).and_return(fake_api)

        get '/data'
        last_response.body.should == "callback(#{{:response => []}.to_json})"
      end
    end

    describe "with API error" do
      it "should return error message" do
        EpticaAPI.should_receive(:get).and_return('{ "status" : 404, "code" : "EPTICA_ERR_RESOURCE_NOT_FOUND", "message" : "There is no resource for path : /selfdemoavv/api/configurations/" }')
        
        get '/data'
        last_response.body.should == "callback(#{{:error => 'EPTICA_ERR_RESOURCE_NOT_FOUND(404): There is no resource for path : /selfdemoavv/api/configurations/'}.to_json})"
      end
    end
  end
end
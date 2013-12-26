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
        data = [{"id" => "64","uri" => "/selfdemoavv/api/configuration/sport7/document/64","names" => [{"name" => "Comment choisir sa balle de tennis ?","locale" => "fr_FR"}],"content" => {"uri" => "/selfdemoavv/api/configuration/sport7/document/64/content"},"creator" => {"uri" => "/selfdemoavv/api/configuration/sport7/document/64/creator"},"creationDate" => 1350417928000,"lastModificationDate" => 1350417928000,"ranks" => [],"contacts" => {"uri" => "/selfdemoavv/api/configuration/sport7/document/64/contacts"},"relatedDocuments" => {"uri" => "/selfdemoavv/api/configuration/sport7/document/64/relatedDocuments"},"attachments" => {"uri" => "/selfdemoavv/api/configuration/sport7/document/64/attachments"},"publicationStatus" => "None"}]
        
        fake_eptica = EpticaAPI.new
        fake_eptica.should_receive(:fetch).and_return([{'document' => {'id' => 1}}, {'document' => {'id' => 2}}, {'document' => {'id' => 3}}], data, data, data)
        EpticaAPI.stub(:new).and_return(fake_eptica)

        get '/data', {:pattern => pattern}
        last_response.body.should == "callback(#{{:response => [data, data, data]}.to_json})"
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
        EpticaAPI.should_receive(:get).and_return({"status" => 404, "code" => "EPTICA_ERR_RESOURCE_NOT_FOUND", "message" => "There is no resource for path : /selfdemoavv/api/configurations/"})
        
        get '/data'
        last_response.body.should == "callback(#{{:error => 'EPTICA_ERR_RESOURCE_NOT_FOUND(404): There is no resource for path : /selfdemoavv/api/configurations/'}.to_json})"
      end
    end
  end

  describe "#documents/:id" do
    it 'should feetch document' do
      fake_eptica = EpticaAPI.new
      fake_eptica.should_receive(:document).with("42").and_return(fake_eptica)
      fake_eptica.should_receive(:fetch).and_return({'names' => [{'name' => 'titi'}]}, {'contents' => [{'content' => 'titi'}]})
      EpticaAPI.stub(:new).and_return(fake_eptica)

      get '/documents/42'
    end

    it "should fetch content" do
      fake_eptica = EpticaAPI.new
      fake_eptica.should_receive(:content).and_return(fake_eptica)
      fake_eptica.should_receive(:fetch).and_return({'names' => [{'name' => 'titi'}]}, {'contents' => [{'content' => 'titi'}]})
      EpticaAPI.stub(:new).and_return(fake_eptica)

      get '/documents/42'
    end

    it "should raise if document not found" do
      fake_eptica = EpticaAPI.new
      fake_eptica.should_receive(:fetch).and_raise(EpticaAPI::APIError)
      EpticaAPI.stub(:new).and_return(fake_eptica)

      lambda do
        get '/documents/42'
      end.should raise_error(EpticaAPI::APIError)
    end
  end
end
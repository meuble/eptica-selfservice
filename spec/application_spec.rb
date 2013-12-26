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
      get '/data'
      last_response.header['Content-Type'].include?('application/javascript').should be_true
    end

    describe 'with pattern' do
      it 'should return results' do
        pattern = "pattern"
        get '/data', {:pattern => pattern}
        last_response.body.should == "callback({'response':['réponse 1 : #{pattern}', 'réponse 2 : #{pattern}', 'réponse 3 : #{pattern}', 'réponse 4 : #{pattern}']})"
      end
    end

    describe 'without pattern' do
      it 'should return empty array as response' do
        get '/data'
        last_response.body.should == "callback({'response':[]})"
      end
    end
  end
end
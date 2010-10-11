$: << File.expand_path(File.join(File.dirname(__FILE__), ".."))
require 'application'
require 'spec'
require 'rack/test'

describe "TextDiffer" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
    
  describe "GET /" do
    it "renders the index template" do
      
    end
  end
end
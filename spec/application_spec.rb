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
    it "does not 404" do
      get "/"
      last_response.ok?.should == true
    end

    it "renders the index template" do
      app.new do |erb_app|
        rendered_html = erb_app.erb :index
        get "/"
        last_response.body.should == rendered_html
      end
    end
  end

  describe "POST /" do
  end
end
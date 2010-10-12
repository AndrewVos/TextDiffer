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
    context "with equal left and right" do
      before :each do
        @left = "What about Bob?"
        @right = "What about Bob?"
        post "/", {:left => @left , :right => @right}
      end

      it "sets the content type to json" do
        last_response.content_type.should == "application/json"
      end

      it "returns the left and right values as json" do
        expected_response = {:left => @left, :right => @right}.to_json
        last_response.body.should == expected_response
      end
    end
    
    context "with equal left and right that contain line breaks" do
      before :each do
        @left = "Line breaks\nAgain!"
        @right = "Line breaks\nAgain!"
        post "/", {:left => @left , :right => @right}
      end

      it "should replace the line breaks with xhtml breaks" do
        @left = @left.gsub("\n", "<br />")
        @right = @right.gsub("\n", "<br />")
        expected_response = {:left => @left, :right => @right}.to_json
        last_response.body.should == expected_response
      end
    end
  end
end
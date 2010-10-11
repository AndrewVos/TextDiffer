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
    before :each do
      @left = "hello theeerre!"
      @right = "and now for something completely different"
      
      Differ.format = :html
      @diffed_text = Differ.diff(@left, @right).to_s
      post "/", {:left => @left, :right => @right}
    end
    
    it "renders the diffed text" do
      last_response.body.should include @diffed_text
    end
    
    it "renders the left text" do
      last_response.body.should include %{<textarea name="left">#{@left}</textarea>}
    end
    
    it "renders the right text" do
      last_response.body.should include %{<textarea name="right">#{@right}</textarea>}
    end
  end
end
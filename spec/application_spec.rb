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
    context "with single line left and right text" do
      before :each do
        @left = "hello theeerre!"
        @right = "and now for something completely different"

        Differ.format = :html
        @diffed_text = Differ.diff(@left, @right).to_s
        post "/", {:left => @left, :right => @right}
      end

      it "renders the diffed text" do
        last_response.body.should include %{<div>#{@diffed_text}</div>}
      end

      it "renders the left text" do
        last_response.body.should include %{<textarea name="left">#{@left}</textarea>}
      end

      it "renders the right text" do
        last_response.body.should include %{<textarea name="right">#{@right}</textarea>}
      end
    end

    context "with multiline left and right text" do
      context "unix style line breaks" do
        before :each do
          @left = "hello theeerre!\nthis goes on a new line!"
          @right = "and now for something completely different\nand this goes on another new line"

          Differ.format = :html
          @diffed_text = Differ.diff(@left, @right).to_s
          post "/", {:left => @left, :right => @right}
        end
        it "renders the diffed text with all line breaks replaced with <br />" do
          line_break_text = @diffed_text.gsub("\n", "<br />")
          last_response.body.should include %{<div>#{line_break_text}</div>}
        end

      end
      context "windows style line breaks" do
        before :each do
          @left = "hello theeerre!\r\nthis goes on a new line!"
          @right = "and now for something completely different\r\nand this goes on another new line"

          Differ.format = :html
          @diffed_text = Differ.diff(@left, @right).to_s
          post "/", {:left => @left, :right => @right}
        end

        it "renders the diffed text with all line breaks replaced with <br />" do
          line_break_text = @diffed_text.gsub("\r", "").gsub("\n", "<br />")
          last_response.body.should include %{<div>#{line_break_text}</div>}
        end
      end
    end
  end
end
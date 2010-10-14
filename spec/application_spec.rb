$: << File.expand_path(File.join(File.dirname(__FILE__), ".."))
require 'application'
require 'spec'
require 'rack/test'
set :environment, :test


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
        @left = "WhatAboutBob?"
        @right = "WhatAboutBob?"
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

    context "with equal left and right that contain spaces and line breaks" do
      before :each do
        @left = "Line breaks\nand spaces!"
        @right = "Line breaks\nand spaces!"
        post "/", {:left => @left , :right => @right}
      end

      it "should replace the line breaks with html breaks and the spaces with non-breaking spaces" do
        expected_response = {
          :left => "Line&nbsp;breaks<br/>and&nbsp;spaces!",
           :right => "Line&nbsp;breaks<br/>and&nbsp;spaces!"
          }.to_json
        last_response.body.should == expected_response
      end
    end

    context "with left that contains one more character than right" do
      before :each do
        @left = "hello"
        @right = "hell"
        post "/", {:left => @left , :right => @right}
      end

      it "should respond with the differences in html" do
        expected_response = {
          :left => %{hell<span class="change">o</span>},
          :right => %{hell<span class="change">&nbsp;</span>}
        }.to_json
        last_response.body.should == expected_response
      end
    end
    
    context "with right that contains one more character than left" do
      before :each do
        @left = "hell"
        @right = "hello"
        post "/", {:left => @left , :right => @right}
      end
      
      it "should respond with the differences in html" do
        expected_response = {
          :left => %{hell<span class="change">&nbsp;</span>},
          :right => %{hell<span class="change">o</span>}
        }.to_json
        last_response.body.should == expected_response
      end
    end
    
    context "with right that contains one single difference" do
      before :each do
        @left = "hallo"
        @right = "hello"
        post "/", {:left => @left , :right => @right}
      end
      
      it "should respond with the differences in html" do
        expected_response = {
          :left => %{h<span class="change">a</span>llo},
          :right => %{h<span class="change">e</span>llo}
        }.to_json
        last_response.body.should == expected_response
      end 
    end
    
    context "with equal left and right that contain html characters" do
      before :each do
        @left = "<html>"
        @right = "<html>"
        post "/", {:left => @left , :right => @right}
      end
      
      it "should respond with the differences in html" do
        expected_response = {
          :left => %{&lt;html&gt;},
          :right => %{&lt;html&gt;}
        }.to_json
        last_response.body.should == expected_response
      end
    end
    
    context "with left and right that contain a different amount of lines" do
      before :each do
        @left = "1\n2\n3"
        @right = "1\n2"
        post "/", {:left => @left , :right => @right}
      end
      
      it "should respond with the differences in html" do
        expected_response = {
          :left => %{1<br/>2<br/><span class="change">3</span>},
          :right => %{1<br/>2<br/><span class="change">&nbsp;</span>}
        }.to_json
        last_response.body.should == expected_response
      end
    end
  end
end
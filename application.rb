require 'rubygems'
require 'sinatra'
require 'differ'
require 'json'

get "/?" do
  erb :index
end

post "/?" do
  content_type :json
  
  left = params[:left]
  right = params[:right]
  left = encode_html(left)
  right = encode_html(right)

  json = {:left => left, :right => right}.to_json
end

def encode_html(text)
  text = text.gsub("\n", "<br/>")
  text = text.gsub(" ", "&nbsp;")
  text
end
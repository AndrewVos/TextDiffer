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

  left = left.gsub("\n", "<br />")
  right = left.gsub("\n", "<br />")

  json = {:left => left, :right => right}.to_json
end
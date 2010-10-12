require 'rubygems'
require 'sinatra'
require 'differ'

get "/?" do
  erb :index
end

post "/?" do
  puts params[:left]
end
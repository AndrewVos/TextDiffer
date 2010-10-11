require 'rubygems'
require 'sinatra'
require 'differ'

get "/?" do
  erb :index
end

post "/?" do
  Differ.format = :html
  result = Differ.diff(params[:left], params[:right]).to_s
  erb :index, :locals => {
    :left => params[:left],
    :right => params[:right],
    :result => result
  }
end
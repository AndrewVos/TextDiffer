require 'rubygems'
require 'sinatra'
require 'diff/lcs'
require 'json'
require 'htmlentities'

get "/?" do
  erb :index
end

post "/?" do
  content_type :json

  left = params[:left]
  right = params[:right]

  left_html = ""
  right_html = ""

  Diff::LCS::sdiff(left, right).each do |change|
    old_element = encode_html(change.old_element)
    new_element = encode_html(change.new_element)
    
    if change.action == "+"
      right_html += %{<span class="add">#{new_element}</span>}  
    elsif change.action == "-"
      left_html += %{<span class="add">#{old_element}</span>}
    elsif change.action == "!"
      left_html += %{<span class="change">#{old_element}</span>}
      right_html += %{<span class="change">#{new_element}</span>}
    else
      left_html += old_element
      right_html += new_element
    end
  end
  
  {:left => left_html, :right => right_html}.to_json
end

def encode_html(text)
  text = "" if text == nil
  
  text = HTMLEntities.new.encode(text)  
  text = text.gsub(" ", "&nbsp;")
  text = text.gsub("\n", "<br/>")
  text
end
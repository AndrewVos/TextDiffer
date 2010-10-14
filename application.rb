require 'rubygems'
require 'sinatra'
require 'diff/lcs'
require 'json'

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
    old_element = ""
    new_element = ""
    old_element = change.old_element.gsub("\n", "<br/>").gsub(" ", "&nbsp;") if change.old_element != nil
    new_element = change.new_element.gsub("\n", "<br/>").gsub(" ", "&nbsp;") if change.new_element != nil
    
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

  #left_html = encode_html(left_html)
  #right_html = encode_html(right_html)

  {:left => left_html, :right => right_html}.to_json
end

def encode_html(text)
  text = text.gsub("\n", "<br/>")
  text = text.gsub("  ", "&nbsp;&nbsp;")
  text
end
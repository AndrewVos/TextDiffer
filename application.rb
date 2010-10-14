require 'rubygems'
require 'sinatra'
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

  left_split = left.split("\n")
  right_split = right.split("\n")

  if left_split.length > right_split.length
    1.upto(left_split.length - right_split.length) do
      right_split << ""
    end
  elsif right_split.length > left_split.length
    1.upto(right_split.length - left_split.length) do
      left_split << ""
    end
  end

  for line_index in 0...left_split.length
    left_line = left_split[line_index]
    right_line = right_split[line_index]

    left_line = "" if left_line == nil
    right_line = "" if right_line == nil

    left_line = left_line.ljust(right_line.length)
    right_line = right_line.ljust(left_line.length)

    for character_index in 0...left_line.length
      left_character = encode_html(left_line[character_index, 1])
      right_character = encode_html(right_line[character_index, 1])
      if left_character == right_character
        left_html += left_character
        right_html += right_character
      else
        left_html += %{<span class="change">#{left_character}</span>}
        right_html += %{<span class="change">#{right_character}</span>}
      end
    end
    if line_index != left_split.length - 1
      left_html += "<br/>"
      right_html += "<br/>"
    end
  end


  {:left => left_html, :right => right_html}.to_json
end

def encode_html(text)
  text = "" if text == nil

  text = HTMLEntities.new.encode(text)  
  text = text.gsub(" ", "&nbsp;")
  text
end
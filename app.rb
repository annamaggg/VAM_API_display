require 'httparty'
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  def location_req(param)
    @item_list = []
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?#{param}")
    if response.code == 200
      data = response.parsed_response['records']
      data.each do |item|
        @item_list << {
          'name' => item['_primaryTitle'],
          'type' => item['objectType'],
          'date' => item['_primaryDate'],
          'imageID' => item['_primaryImageId']
        }
      end
    else 
      puts "bad req"
    end
    return erb(:index)
  end

  get '/' do
    @item_list = []
    return erb(:index)
  end

  get '/search/London' do
    location_req('q_place_name=London')
  end

  get '/search/Amsterdam' do
    location_req('id_place=x28722')
  end
end
#   get '/' do
#     "Hello World"
#     @glass_items = []
#     response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?id_material=AAT10797")
#     if response.code == 200
#       data = response.parsed_response['records']
#       data.each do |item|
#         @glass_items << {
#           'name' => item['objectType'],
#           'date' => item['_primaryDate'],
#           'imageID' => item['_primaryImageId']
#         }
#       end
#       # puts @glass_items
#     else 
#       puts "bad req"
#     end

#     @london_items = []
#     response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?q_place_name=London")
#     if response.code == 200
#       data = response.parsed_response['records']
#       data.each do |item|
#         @london_items << {
#           'type' => item['objectType'],
#           'name' => item['_primaryTitle'],
#           'date' => item['_primaryDate'],
#           'imageID' => item['_primaryImageId']
#         }
#       end
       
#     else 
#       puts "bad req"
#     end
#       return erb(:index)
#   end
 
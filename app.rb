require 'httparty'
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    "Hello World"
    @glass_items = []
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?id_material=AAT10797")
    if response.code == 200
      data = response.parsed_response['records']
      data.each do |item|
        @glass_items << {
          'name' => item['objectType'],
          'date' => item['_primaryDate'],
          'image' => item['_images']['_primary_thumbnail']
        }
      end
      puts @glass_items
    else 
      puts "bad req"
    end
  end
end
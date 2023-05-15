require 'httparty'
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  set :public_folder, File.dirname(__FILE__) + '/public'

  def location_req(param)
    @item_list = []
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?#{param}")
    if response.code == 200
      data = response.parsed_response['records']
      data.each do |item|
        if item['_primaryImageId'] != "" && item['_primaryImageId'] != nil
          @item_list << {
            'name' => item['_primaryTitle'],
            'type' => item['objectType'],
            'date' => item['_primaryDate'],
            'imageID' => item['_primaryImageId']
          }
        end
      end
    else 
      puts "bad request"
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

  get '/search/NewYork' do
    location_req('id_place=x29030')
  end

  get '/search/Moscow' do
    location_req('id_place=x32457')
  end

  get '/search/Paris' do
    location_req('id_place=x29068')
  end

  get '/search/Sydney' do
    location_req('id_place=x37347')
  end

  get '/search/CapeTown' do
    location_req('id_place=x38584')
  end

  get '/search/Tokyo' do
    location_req('id_place=x32204')
  end

  get '/style-image' do 
    return erb(:style_transfer)
  end
end

 
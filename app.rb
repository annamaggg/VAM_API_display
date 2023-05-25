require 'httparty'
require 'sinatra/base'
require 'sinatra/reloader'
# require 'sinatra/session'
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'
require_relative 'lib/artefact_repository'

DatabaseConnection.connect('my_va_test')

class Application < Sinatra::Base
  enable :sessions
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
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    repo = AccountRepository.new
    account = Account.new
    account.username = params[:username]
    account.email = params[:email]
    account.passkey = params[:passkey]

    repo.create(account)
    return erb(:account_created)
  end

  get '/login' do 
    return erb(:login)
  end 

  post '/login' do 
    account_repo = AccountRepository.new
    all_usernames = account_repo.usernames

    if all_usernames.include? params[:username]

      account = account_repo.find_by_username(params[:username])

      if params[:passkey] == account.passkey
        session.clear
        session[:user_id] = account.id
        @current_user = account.username
        if session[:user_id] == nil
          return "no session"
        else
          # redirect '/login_success'
          erb(:login_success)
        end
      else
        @error = "Password is incorrect, please try again"
        erb(:login)
      end
    else 
      @error = "Username does not exist"
      erb(:login)
    end
  end

  # get '/' do
  #   @item_list = []
  #   return erb(:index)
  # end

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

  # material

  get '/search/Wood' do
    location_req('id_material=AAT11914')
  end

  get '/search/Marble' do
    location_req('id_material=AAT11443')
  end

  get '/search/Silver' do
    location_req('id_material=AAT11029')
  end

  get '/search/Plastic' do
    location_req('id_material=AAT14570')
  end

  get '/search/Gold' do
    location_req('id_material=AAT11021')
  end

  get '/search/Bronze' do
    location_req('id_material=AAT10957')
  end

  get '/search/Paper' do
    location_req('id_material=AAT14109')
  end



  get '/style-image' do 
    return erb(:style_transfer)
  end
end

 
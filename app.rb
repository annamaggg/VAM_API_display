require 'httparty'
require 'sinatra/base'
require 'sinatra/reloader'
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

  def search_req(param)
    item_list = []
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?q=\"#{param}\"")
    if response.code == 200
      data = response.parsed_response['records']
      data.each do |item|
        if item['_primaryImageId'] != "" && item['_primaryImageId'] != nil
          item_list << {
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
    item_list
  end

  def randomiser()
    req_params = ['gold', 'silver', 'wood', 'glass', 'marble', 'plastic', 'Queen Victoria', 'Prince Albert', 'city', 'book', 'drawing', 'sketch', 'painting','poster', 'photograph', 'film', 'music', 'London', 'Tokyo', 'Amsterdam', 'New York', 'Moscow', 'Sydney', 'Paris', 'blue', 'green', 'yellow', 'red', 'purple', 'white', 'black', 'orange', 'map', 'flower', 'home', '1', '2', '3', 'century', 'collection', 'model', 'print', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's']
    rand_search = rand(0...(req_params.length))
    keyword = req_params[rand_search]
    search_results = search_req(keyword)
    rand_result = rand(0...(search_results.length))
    puts "your keyword is " + keyword + ", your search results are: " +  search_results.to_s + "your rand result number is: " + rand_result.to_s
    return search_results[rand_result]
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

    if params[:username] != "" || params[:email] != "" || params[:passkey] = !""
      repo.create(account)
      session.clear
      new_account = repo.find_by_username(params[:username])
      session[:user_id] = new_account.id
      redirect '/homepage'
    else
      puts "insufficient entry"
      redirect "/signup"
    end
  end

  get '/login' do 
    if session[:user_id] != nil
      erb(:user_homepage)
    else
      return erb(:login)
    end
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
          redirect '/homepage'
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

  get '/logout' do
    return erb(:logout)
  end

  post '/logout' do
    session.clear
    return erb(:login)
  end

  get '/homepage' do
    @rand_item = randomiser()
    return erb(:user_homepage)
  end

  get '/search' do 
    if params[:keyword]
      session[:latest_keyword] = params[:keyword]
    end
  
    if session[:latest_keyword] != nil
      @item_list = search_req(session[:latest_keyword])
    else
      @item_list = []
    end
    return erb(:search)
  end

  post '/search' do
    session[:latest_keyword] = params[:keyword]
    @item_list = search_req(params[:keyword])
    return erb(:search)
  end

  def add_to_collection(params)
    artefact_repo = ArtefactRepository.new
    artefact = Artefact.new
    artefact.title = params[:name]
    artefact.object_type = params[:type]
    artefact.time_period = params[:date]
    artefact.image_id = params[:imageID]
    artefact.account_id = session[:user_id]
    artefact_repo.add_artefact(artefact)
  end

  post '/add-to-collection-within-search' do
    if session[:user_id] != nil 
      add_to_collection(params)
    end
    redirect "/search?keyword=#{session[:latest_keyword]}"
  end

  post '/add-to-collection' do
    if session[:user_id] != nil 
      add_to_collection(params)
    end
    redirect "/homepage"
  end

  # post '/add-to-collection' do
  #   if session[:user_id] != nil 
  #     artefact_repo = ArtefactRepository.new
  #     artefact = Artefact.new
  #     artefact.title = params[:name]
  #     artefact.object_type = params[:type]
  #     artefact.time_period = params[:date]
  #     artefact.image_id = params[:imageID]
  #     artefact.account_id = session[:user_id]
  #     artefact_repo.add_artefact(artefact)
  #   end
  #   redirect "/search?keyword=#{session[:latest_keyword]}"
  # end

  get '/my-collection' do
    if session[:user_id] != nil 
      artefact_repo = ArtefactRepository.new
      @my_artefacts = artefact_repo.artefacts_by_account_id(session[:user_id])
      return erb(:my_collection)
    else 
      return erb(:login)
    end
  end

  # get '/' do
  #   @item_list = []
  #   return erb(:index)
  # end

  # get '/search/London' do
  #   location_req('q_place_name=London')
  # end

  # get '/search/Amsterdam' do
  #   location_req('id_place=x28722')
  # end

  # get '/search/NewYork' do
  #   location_req('id_place=x29030')
  # end

  # get '/search/Moscow' do
  #   location_req('id_place=x32457')
  # end

  # get '/search/Paris' do
  #   location_req('id_place=x29068')
  # end

  # get '/search/Sydney' do
  #   location_req('id_place=x37347')
  # end

  # get '/search/CapeTown' do
  #   location_req('id_place=x38584')
  # end

  # get '/search/Tokyo' do
  #   location_req('id_place=x32204')
  # end

  # # material

  # get '/search/Wood' do
  #   location_req('id_material=AAT11914')
  # end

  # get '/search/Marble' do
  #   location_req('id_material=AAT11443')
  # end

  # get '/search/Silver' do
  #   location_req('id_material=AAT11029')
  # end

  # get '/search/Plastic' do
  #   location_req('id_material=AAT14570')
  # end

  # get '/search/Gold' do
  #   location_req('id_material=AAT11021')
  # end

  # get '/search/Bronze' do
  #   location_req('id_material=AAT10957')
  # end

  # get '/search/Paper' do
  #   location_req('id_material=AAT14109')
  # end



  get '/style-image' do 
    return erb(:style_transfer)
  end
end

 
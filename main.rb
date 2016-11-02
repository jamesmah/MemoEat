require 'pry'
require 'sinatra'
require 'httparty'
require 'uri'
require 'bcrypt'
require_relative 'db_config'
require_relative 'models/restaurant'
require_relative 'models/user'

enable :sessions

helpers do

  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

end


get '/' do
  redirect to '/' + current_user['username'] if logged_in?

  erb :login
end

get '/home' do
  redirect to '/'
end

get '/login' do
  redirect to '/'

end

get '/signup' do

  erb :signup
end

post '/signup' do
  if !!User.find_by(username: params[:username])
    # do if user already exists
    redirect to '/signup'
  end

  user = User.new
  user.name = params[:name]
  user.username = params[:username]
  user.email = params[:email]
  user.password_digest = BCrypt::Password.create(params[:password])
  user.location_id = 259
  user.description = params[:description]

  if user.save
    session[:user_id] = user.id
    redirect to '/' + current_user['username']
  else
    redirect to '/signup'
  end
end

get '/edituser' do
  @user = User.find_by(id: session[:user_id])
  erb :edituser, :layout => :layout_userpages
end

patch '/edituser' do
  user = User.find_by(id: session[:user_id])
  if !user
    # do if user already exists
    redirect to 'edituser'
  end

  user.name = params[:name]
  user.username = params[:username]
  user.email = params[:email]
  if !!params[:password]
    user.password_digest = BCrypt::Password.create(params[:password])
  end
  user.location_id = 259
  user.description = params[:description]

  if user.save
    redirect to '/edituser'
  else
    redirect to '/edituser'
  end
end

post '/session' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])

    session[:user_id] = user.id
    redirect to '/' + current_user['username']
  else
    redirect to '/'
  end
end

delete '/session' do
  # remove the session
  session[:user_id] = nil
  redirect to '/'
end


# home directory

delete '/home/:restaurant_id' do
  Restaurant.find_by(id: params[:restaurant_id]).destroy
  redirect to '/' + current_user['username']
end

patch '/home/archive/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['archive'] = true
  restaurant.save
  redirect to '/' + current_user['username']
end

patch '/home/notes/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['notes'] = params[:notes]
  restaurant.save
  redirect to '/' + current_user['username']
end

patch '/home/rating/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  if restaurant['rating'] == params[:rating].to_i
    restaurant['rating'] = 0
  else
    restaurant['rating'] = params[:rating]
  end
  restaurant.save
  redirect to '/' + current_user['username']
end


# history directory
get '/history' do
  redirect to '/' unless logged_in?

  @restaurants = Restaurant.where(user_id: session[:user_id], archive: true).order("id ASC")

  erb :history, :layout => :layout_userpages
end

delete '/history/:restaurant_id' do
  Restaurant.find_by(id: params[:restaurant_id]).destroy
  redirect to '/history'
end

patch '/history/unarchive/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['archive'] = false
  restaurant.save
  redirect to '/history'
end

patch '/history/notes/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['notes'] = params[:notes]
  restaurant.save
  redirect to '/history'
end

patch '/history/rating/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  if restaurant['rating'] == params[:rating].to_i
    restaurant['rating'] = 0
  else
    restaurant['rating'] = params[:rating]
  end
  restaurant.save
  redirect to '/history'
end

get '/search' do
  redirect to '/' unless logged_in?

  url_string = "https://developers.zomato.com/api/v2.1/search?"

  search_params = {
    apikey: "c60221a0e2f91ebbc3faa2b40bf0658c",
    entity_id: 259,
    entity_type: "city",
    country_id: 14,
    q: params[:q],
    sort: "rating",
    order: "desc",
  }

  search_params.each do |key, value|
    url_string += "\&#{key}\=#{value}"
  end

  result = HTTParty.get(URI.escape(url_string))
  @restaurants = result['restaurants']

  erb :search, :layout => :layout_userpages
end


post '/addnew' do
  restaurant = Restaurant.new
  restaurant.user_id = session[:user_id]
  restaurant.zomato_id = params[:zomato_id]
  restaurant.name = params[:name]
  restaurant.address = params[:address]
  restaurant.cuisines = params[:cuisines]
  restaurant.price_range = params[:price_range]
  restaurant.photo_url = params[:photo_url]
  if !restaurant.rating = params[:rating]
    restaurant.rating = 0
  end
  restaurant.notes = params[:notes]
  restaurant.archive = false

  restaurant.save
  # binding.pry

  # redirect to "/search?q=#{params[:q]}"
  redirect to '/' + current_user['username']
end

get '/add' do
  erb :add, :layout => :layout_userpages
end

# get '/:username/edituser' do
#   erb :edituser, :layout => :layout_userpages
# end

get '/:username' do
  if (!!@user = User.find_by(username: params[:username]) ) && logged_in?
    @restaurants = Restaurant.where(user_id: @user['id'], archive: false).order("id ASC")

    if logged_in?
      erb :home, :layout => :layout_userpages
    else
      erb :home
    end
  end
end

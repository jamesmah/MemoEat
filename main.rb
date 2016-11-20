require 'pry'
require 'sinatra'
require 'httparty'
require 'uri'
require 'bcrypt'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/restaurant'

### Session controller

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end

get '/' do
  redirect to '/browse'
end

get '/login' do
  erb :'session/new'
end

post '/login' do
  @username = params[:username]
  user = User.where("lower(username) =?", @username.downcase).first
  if !user
    user = User.where("lower(email) =?", @username.downcase).first
  end

  if !user
    @username_error = "*invalid username/email"
    erb :'session/new'
  elsif !user.authenticate(params[:password])
    @password_error = "*incorrect password"
    erb :'session/new'
  else
    session[:user_id] = user.id
    redirect to '/' + current_user['username']
  end
end

delete '/login' do
  session[:user_id] = nil
  redirect to '/login'
end


### Users controller

get '/signup' do
  @user = User.new
  @errors = {}
  erb :'users/new'
end

post '/signup' do
  @user = User.new
  @user.name = params[:name]
  @user.username = params[:username]
  @user.email = params[:email]
  @user.location_id = params[:location_id]
  @user.description = params[:description]
  @user.password = params[:password]
  @user.password_confirmation = params[:password_confirmation]
  @user.password_digest = BCrypt::Password.create(params[:password])

  @errors = {}
  if @user.save
    session[:user_id] = @user.id
    redirect to '/' + current_user['username']
  else
    @user.errors.messages.each do |key, value|
      if value.any?
        @errors[key] = '*' + value.join(', ')
      end
    end
    erb :'users/new'
  end  
end

get '/settings' do
  redirect to '/' unless logged_in?

  @user = User.find_by(id: session[:user_id])
  @errors = {}

  erb :'users/edit'
end

patch '/settings' do
  @user = User.find_by(id: session[:user_id])
  @user.name = params[:name]
  @user.username = params[:username]
  @user.email = params[:email]
  @user.location_id = params[:location_id]
  @user.description = params[:description]

  password_verified = @user.authenticate(params[:password_old])
  if password_verified
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.password_digest = BCrypt::Password.create(params[:password])
  end

  @errors = {}
  if !password_verified && params[:password_old] != ""
    @errors[:password_old] = "*Incorrect password"
  else
    if @user.save
      @saved_message = "Saved!"
    else
      @user.errors.messages.each do |key, value|
        if value.any?
          @errors[key] = '*' + value.join(', ')
        end
      end
    end
  end

  erb :'users/edit'
end

delete '/users/:user_id' do
  if params[:user_id] == session[:user_id]
    User.find_by(id: params[:user_id]).destroy
  end
  session[:user_id] = nil
  redirect to '/'
end


### Restaurants controller

get '/add' do
  redirect to '/' unless logged_in?

  @restaurant = Restaurant.new
  @errors = {}

  erb :'restaurants/new'
end

post '/add' do
  @restaurant = Restaurant.new
  @restaurant.user_id = session[:user_id]
  @restaurant.zomato_id = params[:zomato_id]
  @restaurant.name = params[:name]
  @restaurant.address = params[:address]
  @restaurant.cuisines = params[:cuisines]
  @restaurant.price_range = params[:price_range]
  @restaurant.photo_url = params[:photo_url]
  @restaurant.rating = params[:rating]
  @restaurant.notes = params[:notes]
  @restaurant.archive = false
  @restaurant.image = params[:image]

  @errors = {}
  if @restaurant.save
    if !!params[:image] 
      @restaurant.photo_url = @restaurant.image.url
      @restaurant.save
    end

    if !!params[:dir]
      redirect to '/' + params[:dir]
    end
    redirect to '/' + current_user['username']
  else
    @restaurant.errors.messages.each do |key, value|
      if value.any?
        @errors[key] = '*' + value.join(', ')
      end
    end
    erb :'restaurants/new'
  end
end

post '/api/restaurant' do
  @restaurant = Restaurant.new
  @restaurant.user_id = session[:user_id]
  @restaurant.zomato_id = params[:zomato_id]
  @restaurant.name = params[:name]
  @restaurant.address = params[:address]
  @restaurant.cuisines = params[:cuisines]
  @restaurant.price_range = params[:price_range]
  @restaurant.photo_url = params[:photo_url]
  @restaurant.rating = params[:rating]
  @restaurant.notes = params[:notes]
  @restaurant.archive = false

  if @restaurant.save
    return { 'success' => true }.to_json
  else
    return { 'success' => false }.to_json
  end
end

patch '/restaurant/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])

  if !!params[:archive]
    restaurant.archive = params[:archive]
  end

  if !!params[:notes]
    restaurant.notes = params[:notes]
  end

  if !!params[:rating]
    if restaurant.rating == params[:rating].to_i
      restaurant.rating = nil
    else
      restaurant.rating = params[:rating]
    end
  end

  restaurant.save
  if !!params[:dir]
    redirect to '/' + params[:dir]
  else
    redirect to '/' + current_user['username']
  end
end

patch '/api/restaurant/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])

  if !!params[:archive]
    restaurant.archive = params[:archive]
  end

  if !!params[:notes]
    restaurant.notes = params[:notes]
  end

  if !!params[:rating]
    if restaurant.rating == params[:rating].to_i
      restaurant.rating = nil
    else
      restaurant.rating = params[:rating]
    end
  end

  restaurant.save
  return restaurant.to_json
end

delete '/restaurant/:restaurant_id' do
  Restaurant.find_by(id: params[:restaurant_id]).destroy

  if !!params[:dir]
    redirect to '/' + params[:dir]
  else
    redirect to '/' + current_user['username']
  end
end

delete '/api/restaurant/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant.destroy

  if !restaurant.destroyed?x
    return { 'success' => false }.to_json
  end
  return { 'success' => true }.to_json
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
    # sort: "rating",
    # order: "desc",
  }
  search_params.each do |key, value|
    url_string += "\&#{key}\=#{value}"
  end
  result = HTTParty.get(URI.escape(url_string))
  @restaurants = result['restaurants']

  @dir = "search?q=" + params[:q]
  erb :'restaurants/search'
end

get '/browse' do
  @header = "Recent finds"

  if logged_in?
    @restaurants = Restaurant.where.not(user_id: session[:user_id]).order('id DESC').limit(40)
  else
    @restaurants = Restaurant.all.order('id DESC').limit(40)
  end

  @restaurants = @restaurants.to_a.shuffle!
  @restaurants.uniq! do |restaurant|
    if !!restaurant.zomato_id
      restaurant.zomato_id
    else
      restaurant.address
    end
  end

  @restaurants.sort! { |x,y|
    y.id <=> x.id
  }

  @dir = "browse"
  erb :'restaurants/index'
end

get '/:username' do
  user = User.find_by(username: params[:username])

  if !user
    redirect to '/'
  end

  if user == current_user
    @header = "My Memos"
    @restaurants = Restaurant.where(user_id: user.id, archive: false).order("id DESC")
  else
    @header = user.name + "'s Memos"
    @restaurants = Restaurant.where(user_id: user.id).order("id DESC")
  end

  @dir = params[:username]
  erb :'restaurants/index'
end

get '/:username/' do
  redirect to '/' + params[:username]
end

get '/:username/archive' do
  user = User.find_by(username: params[:username])

  if !user == current_user
    redirect to '/'
  end

  @header = "My Archive"
  @restaurants = Restaurant.where(user_id: session[:user_id], archive: true).order("id DESC")

  @dir = params[:username] + "/archive"
  erb :'restaurants/index'
end
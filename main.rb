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
  redirect to '/browse'
end

get '/login' do
  erb :login
end

get '/browse' do
  @dir = "browse"
  @header_logged_in = "Recent finds"
  @header = "Recent finds"

  if logged_in?
    @restaurants = Restaurant.where.not(user_id: session[:user_id]).order('id DESC').limit(40)
  else
    @restaurants = Restaurant.all.order('id DESC').limit(40)
  end

  @restaurants = @restaurants.to_a.shuffle!
  @restaurants.uniq! do |restaurant|
    if !!restaurant['zomato_id']
      restaurant['zomato_id']
    else
      restaurant['address']
    end
  end

  @restaurants.sort! { |x,y|
    y['id'] <=> x['id']
  }

  if logged_in?
    erb :memos, :layout => :layout_userpages
  else
    erb :memos
  end
end

get '/signup' do
  @user = nil
  erb :signup
end

post '/signup' do

  @user = User.new
  @user.name = params[:name]
  @user.username = params[:username]

  if /[^a-zA-Z]+/ === params[:username]
    @username_error = "*Invalid username. No special characters or spacing."
  end


  @user.email = params[:email]

  if params[:password] == params[:password_verify]
    if params[:password] != ""
      @user.password_digest = BCrypt::Password.create(params[:password])
    end
  else
    @password_verify_error = "Passwords do not match"
  end

  @user.location_id = 259
  @user.description = params[:description]

  if !@username_error && !@password_verify_error && @user.save
    session[:user_id] = @user.id
    redirect to '/' + current_user['username']
  else
    if !@password_verify_error
      @password_error = @user.errors.messages[:password_digest].join(", ")
    end
    # binding.pry
    erb :signup
  end
end


post '/login' do
  @username = params[:username]
  user = User.find_by(username: @username)

  if !user
    @username_error = "Invalid username"
    erb :login
  elsif !user.authenticate(params[:password])
    @password_error = "*Incorrect password"
    erb :login
  else
    session[:user_id] = user.id
    redirect to '/' + current_user['username']
  end
end

delete '/login' do
  session[:user_id] = nil
  redirect to '/login'
end

get '/search' do
  redirect to '/' unless logged_in?

  @dir = "search?q=" + params[:q]

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

  erb :search, :layout => :layout_userpages
end


get '/add' do
  erb :add, :layout => :layout_userpages
end


post '/restaurant' do
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
  # binding.pry

  if @restaurant.save
    binding.pry
    if !!@restaurant.image
      @restaurant.photo_url = @restaurant.image.url
      @restaurant.save
    end

    if !!params[:dir]
      redirect to '/' + params[:dir]
    else
      redirect to '/' + current_user['username']
    end
  else
    erb :add, :layout => :layout_userpages
  end

  
end

delete '/restaurant/:restaurant_id' do
  Restaurant.find_by(id: params[:restaurant_id]).destroy
  if !!params[:dir]
    redirect to '/' + params[:dir]
  else
    redirect to '/' + current_user['username']
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

get '/settings' do
  @user = User.find_by(id: session[:user_id])
  erb :settings, :layout => :layout_userpages
end

patch '/settings' do

  @user = User.find_by(id: session[:user_id])

  @user.name = params[:name]

  @user.username = params[:username]

  if /[^a-zA-Z]+/ === params[:username]
    @username_error = "*Invalid username. No special characters or spacing."
  end

  @user.email = params[:email]
  if params[:password_old] != "" 
    if @user.authenticate(params[:password_old])
      @password_old = params[:password_old]
      if !!params[:password_new]
        if params[:password_new] == params[:password_verify]
          if params[:password_new]!= ""
            @user.password_digest = BCrypt::Password.create(params[:password_new])
          else
            @password_new_error = "*No new password"
          end
        else
          @password_verify_error = "*Passwords do not match"
        end
      end
    else
      @password_error = "*Incorrect password"
    end
  end
  @user.location_id = 259
  @user.description = params[:description]

  if !@username_error && !@password_error && !@password_new_error && !@password_verify_error && @user.save
    @password_old = nil
    @saved_message = "Saved!"
    erb :settings, :layout => :layout_userpages
  else
    erb :settings, :layout => :layout_userpages
  end
end


get '/:username' do
  @dir = params[:username]

  if (!!@user = User.find_by(username: params[:username]) )
    @header_logged_in = "My Memos"
    @header = @user['name'] + "'s Memos"


    if @user['id'] == session[:user_id]
      @restaurants = Restaurant.where(user_id: @user['id'], archive: false).order("id ASC")
    else
      @restaurants = Restaurant.where(user_id: @user['id']).order("id DESC")
    end

    if logged_in?
      erb :memos, :layout => :layout_userpages
    else
      erb :memos
    end
  else
    redirect to '/'
  end
end

get '/:username/' do
  redirect to '/' + params[:username]
end

get '/:username/archive' do
  @dir = params[:username] + "/archive"

  @user = User.find_by(id: session[:user_id])
  if @user['username'] == params[:username]
    @header_logged_in = "My Archive"
    @header = @user['name'] + "'s Archive"

    @restaurants = Restaurant.where(user_id: session[:user_id], archive: true).order("id DESC")
    erb :memos, :layout => :layout_userpages
  else
    redirect to '/'
  end
end





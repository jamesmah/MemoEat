require 'pry'
require 'sinatra'
require 'httparty'
require 'uri'
require 'bcrypt'
require_relative 'db_config'
require_relative 'models/restaurant'
require_relative 'models/user'

enable :sessions



get '/' do
  # erb :login, :layout => false
  redirect to '/home'
end

get '/signup' do
  erb :signup, :layout => false
end

get '/home' do
  @restaurants = Restaurant.where(user_id: 1, archive: false).order("id ASC")

  erb :home
end

delete '/home/:restaurant_id' do
  Restaurant.find_by(id: params[:restaurant_id]).destroy
  redirect to '/home'
end

put '/home/archive/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['archive'] = true
  restaurant.save
  redirect to '/home'
end

put '/home/unarchive/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['archive'] = false
  restaurant.save
  redirect to '/history'
end

put '/home/notes/:restaurant_id' do
  restaurant = Restaurant.find_by(id: params[:restaurant_id])
  restaurant['notes'] = params[:notes]
  restaurant.save
  redirect to '/home'
end

get '/search' do

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

  erb :search
end

put '/addnew' do
  restaurant = Restaurant.new
  restaurant.user_id = 1 # change this
  restaurant.zomato_id = params[:zomato_id]
  restaurant.name = params[:name]
  restaurant.address = params[:address]
  restaurant.cuisine = params[:cuisines]
  restaurant.price_range = params[:price_range]
  restaurant.photo_url = params[:photo_url]
  restaurant.archive = false

  restaurant.save
  # binding.pry

  # redirect to "/search?q=#{params[:q]}"
  redirect to "/home"
end


get '/history' do
  @restaurants = Restaurant.where(user_id: 1, archive: true).order("id ASC")

  erb :history
end

get '/newmemo' do
  erb :newmemo
end

get '/edituser' do
  erb :edituser
end


# result = HTTParty.get('http://omdbapi.com/?t=once')
# class Hash
#   def downcase_key
#     keys.each do |k|
#       store(k.downcase, Array === (v = delete(k)) ? v.map(&:downcase_key) : v)
#     end
#     self
#   end
# end


# get '/' do
#   erb :index
# end

# get '/results' do
#   @param = URI.escape(params[:title])
#   @movie = {}
#   @poster = nil

#   open('search_history.txt', 'a') { |f|
#     f.puts @param
#   }
#   if @param == ''
#     redirect "/about?id=#{@param}"
#   else 
#     @movie = HTTParty.get('http://omdbapi.com/?s=' + @param)
#     if @movie['Response'] == 'False'
#       redirect "/about?id=#{@param}"
#     elsif @movie['Search'].length == 1
#       imdbID = @movie['Search'][0]['imdbID']
#       redirect "/about?id=#{imdbID}"
#     else
#       @moviearray = @movie['Search']
#     end
#   end
#   erb :results
# end


# get '/about' do
#   @param = URI.escape(params[:id])
#   @movie = {}
#   @poster = nil

#   if @param == ''
#     @result = 'No movie found'
#   else 
#     if Movie.find_by(imdbid: @param) != nil
#       @movie = Movie.find_by(imdbid: @param).attributes
#     else
#       @movie = HTTParty.get('http://omdbapi.com/?i=' + @param)
#       @movie.downcase_key.delete('type')
#       if @movie['response'] == 'True'
#         Movie.create(@movie)
#       end
#     end
#     if @movie['response'] == 'False'
#       @result = 'No movie found'
#     end
#   end
#   erb :about
# end

# get '/history' do

#   @newarray = []

#   f = File.open("search_history.txt", "r")
#   f.each_line do |line|
#      @newarray << line
#   end
#   f.close

#   erb :history
# end









# require 'bcrypt'

# class User < ActiveRecord::Base
#   # users.password_hash in the database is a :string
#   include BCrypt

#   def password
#     @password ||= Password.new(password_hash)
#   end

#   def password=(new_password)
#     @password = Password.create(new_password)
#     self.password_hash = @password
#   end
# end
# Creating an account

# def create
#   @user = User.new(params[:user])
#   @user.password = params[:password]
#   @user.save!
# end
# Authenticating a user

# def login
#   @user = User.find_by_email(params[:email])
#   if @user.password == params[:password]
#     give_token
#   else
#     redirect_to home_url
#   end
# end
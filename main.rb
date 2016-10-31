require 'pry'
require 'sinatra'
require 'httparty'
require 'uri'
require_relative 'db_config'
require_relative 'models/restaurant'

get '/' do
  erb :index
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






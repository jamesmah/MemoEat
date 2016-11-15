gem 'activerecord'
gem 'sinatra'
gem 'pg'
gem 'bcrypt'
gem 'httparty'
gem 'pry'
gem 'carrierwave'
gem 'fog'
require_relative 'db_config'
require_relative 'models/restaurant'
require_relative 'models/user'

binding.pry
require 'pry'
require 'sinatra'
require 'httparty'
require 'uri'
require 'bcrypt'
require_relative 'db_config'
require_relative 'models/restaurant'
require_relative 'models/user'

binding.pry
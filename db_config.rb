require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'project2'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
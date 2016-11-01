class User < ActiveRecord::Base
  validates :name, length: { minimum: 2 };
  has_secure_password
end
class User < ActiveRecord::Base
  
  
  # Validation constraints
  validates :name, 
    presence: true,
    length: { minimum: 2, maximum: 400 };
  validates :username, 
    presence: true,
    uniqueness: true,
    length: { minimum: 4, maximum: 400 }
  validates :email, 
    presence: true,
    uniqueness: true,
    length: { minimum: 4, maximum: 400 }
  validates :password_digest, 
    presence: true


  # Associations
  has_many :restaurants

  has_secure_password
end
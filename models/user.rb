class User < ActiveRecord::Base
  # Associations
  has_many :restaurants, dependent: :destroy

  # Password validation
  has_secure_password
  
  # Validation constraints
  validates :name, 
    presence: true
  validates :username, 
    presence: true,
    uniqueness: true,
    length: { 
      in: 4..400, 
    },
    format: { 
      without: /[^a-z0-9]/i,
      message: "no special characters or spacing"
    },
    exclusion: { 
      :in => %w(login signup settings add api restaurant search browse archive),
      message: "has already been taken"
    }
  validates :email, 
    presence: true,
    uniqueness: true,
    format: { 
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }
  validates :location_id, 
    presence: true
end
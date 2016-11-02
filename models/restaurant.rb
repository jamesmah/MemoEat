class Restaurant < ActiveRecord::Base
  validates :user_id, 
    presence: true,
    length: { minimum: 1 }
  validates :name, 
    presence: true,
    length: { minimum: 2, maximum: 400 }
  validates :address, 
    presence: true,
    length: { minimum: 4, maximum: 400 }
  validates :cuisines, 
    presence: true,
    length: { minimum: 4, maximum: 400 }
end
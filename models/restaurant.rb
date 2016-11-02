class Restaurant < ActiveRecord::Base
  validates :name, length: { minimum: 2 };
  validates :rating, length: { minimum: 1 };
end
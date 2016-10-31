class Restaurant < ActiveRecord::Base
  validates :name, length: { minimum: 2 };
end
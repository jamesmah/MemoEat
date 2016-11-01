CREATE DATABASE project2;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(400),
  username VARCHAR(400),
  email VARCHAR(400),
  password_digest VARCHAR(400),
  location_id INTEGER,
  description TEXT
);

CREATE TABLE restaurants (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER,
  zomato_id INTEGER,
  name VARCHAR(400),
  address TEXT,
  cuisine VARCHAR(400),
  price_range INTEGER,
  photo_url TEXT,
  rating INTEGER,
  notes TEXT,
  archive BOOLEAN
);
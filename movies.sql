CREATE DATABASE movieswebsite;

CREATE TABLE movies (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(100),
  year VARCHAR(100),
  actors VARCHAR(400),
  awards TEXT,
  country VARCHAR(100),
  director VARCHAR(400),
  genre VARCHAR(400),
  episode VARCHAR(100),
  season VARCHAR(100),
  seriesid varchar(100),
  language VARCHAR(400),
  metascore VARCHAR(100),
  plot TEXT,
  poster TEXT,
  rated VARCHAR(100),
  released VARCHAR(100),
  response VARCHAR(100),
  runtime VARCHAR(100),
  writer VARCHAR(400),
  imdbid VARCHAR(100),
  imdbrating VARCHAR(100),
  imdbvotes VARCHAR(100)
);

CREATE DATABASE project2;
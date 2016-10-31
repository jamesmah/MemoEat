### Movies I

## Specification
Build a search form that lets the user enter a movie name. The Sinatra app will use HTTParty to fetch the data for the chosen movie from OMDB and display it on the page.

- Build a Sinatra application 
	- Include:
		- app.rb		
		- views/layout.erb
		- views/index.erb
		- views/about.erb
		- public/css/style.css

example httparty usage
```
requrie 'httparty'
result = HTTParty.get('http://omdbapi.com/?t=once')

```

## Additional Resources
- [Dynamic URLs in Sinatra](http://blog.teamtreehouse.com/ruby-sinatra-dynamic-urls-tutorial)
- [Open movie database API](http://www.omdbapi.com/)
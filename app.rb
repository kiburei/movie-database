require "sinatra"
  require "sinatra/reloader"
  require "pg"
  require "./lib/movie"
  require "./lib/actor"
  also_reload('/lib/**/*.rb')

  DB = PG.connect({:dbname => 'movie_database'})

  get('/') do
    erb(:index)
  end

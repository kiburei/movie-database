class Movie
  attr_accessor(:name, :id, :actor_ids)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id).to_i
    @actor_ids = []
  end

  def self.all
    returned_movies = DB.exec('SELECT * FROM movies;')
    movies = []
    returned_movies.each do |movie|
      movies.push(Movie.new({:name => movie.fetch('name'), :id => movie.fetch('id')}))
    end
    movies
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM movies WHERE id = #{id};")
    movie = nil
    result.each do |r|
      movie = Movie.new({:name => r.fetch('name'), :id => id})
    end
    movie
  end

  def save
    result = DB.exec("INSERT INTO movies (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  def ==(another_movie)
    self.name.==(another_movie.name).&(self.id.==(another_movie.id))
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE movies SET name = '#{@name}' WHERE id = #{self.id}")
    attributes.fetch(:actor_ids, []).each do |actor_id|
      DB.exec("INSERT INTO actors_movies (actor_id, movie_id) VALUES (#{actor_id}, #{self.id});")
    end
  end

  def actors
    actors = DB.exec("SELECT actor_id FROM actors_movies WHERE movie_id = #{self.id};")
    movie_actors = []
    actors.each() do |actor|
      actor_id = actor.fetch("actor_id").to_i()
      my_actor = DB.exec("SELECT * FROM actors WHERE id = #{actor_id};")
      movie_actors.push(Actor.new(:name =>  my_actor.first().fetch('name'), :id => actor_id ))
    end
    movie_actors
  end


  def delete
    DB.exec("DELETE FROM actors_movies WHERE movie_id = #{self.id};")
    DB.exec("DELETE FROM movies WHERE id = #{self.id}")
  end
end

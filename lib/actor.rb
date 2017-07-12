class Actor
  attr_accessor(:name, :id, :movie_ids)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id).to_i
    @movie_ids = []
  end

  def self.all
    returned_actors = DB.exec('SELECT * FROM actors;')
    actors = []
    returned_actors.each do |actor|
      actors.push(Actor.new({:name => actor.fetch('name'), :id => actor.fetch('id')}))
    end
    actors
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM actors WHERE id = #{id};")
    actor = nil
    result.each do |r|
      actor = Actor.new({:name => r.fetch('name'), :id => id})
    end
    actor
  end

  def save
    result = DB.exec("INSERT INTO actors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  def ==(another_actor)
    self.name.==(another_actor.name).&(self.id.==(another_actor.id))
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id
    DB.exec("UPDATE actors SET name = '#{@name}' WHERE id = #{@id}")
  end

  def movies
    movies = DB.exec("SELECT movie_id FROM actors_movies WHERE actor_id = #{self.id};")
    actor_movies = []
    movies.each() do |movie|
      movie_id = movie.fetch("movie_id").to_i()
      my_movie = DB.exec("SELECT * FROM movies WHERE id = #{movie_id};")
      actor_movies.push(Movie.new(:name =>  my_movie.first().fetch('name'), :id => movie_id ))
    end
    actor_movies
  end

  def delete
    DB.exec("DELETE FROM actors_movies WHERE actor_id = #{self.id};")
    DB.exec("DELETE FROM actors WHERE id = #{self.id}")
  end
end

require "rspec"
require "movie"
require "actor"
require "pg"

DB = PG.connect({:dbname => 'movie_database_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM movies *;')
    DB.exec('DELETE FROM actors_movies *')
  end
end

  describe(Movie) do


    describe(".all") do
      it("starts off with no movies") do
        expect(Movie.all()).to(eq([]))
      end
    end

    describe(".find") do
      it("returns a movie by its ID number") do
        test_movie = Movie.new({:name => "Oceans Eleven", :id => nil})
        test_movie.save()
        test_movie2 = Movie.new({:name => "Oceans twelve", :id => nil})
        test_movie2.save()
        expect(Movie.find(test_movie2.id())).to(eq(test_movie2))
      end
    end

    describe("#==") do
      it("is the same movie if it has the same name and id") do
        movie = Movie.new({:name => "Oceans Eleven", :id => nil})
        movie2 = Movie.new({:name => "Oceans Eleven", :id => nil})
        expect(movie).to(eq(movie2))
      end
    end

    describe("#update") do
      it("lets you update movies in the database") do
        movie = Movie.new({:name => "Oceans Eleven", :id => nil})
        actor = Actor.new({:name => "Rami Malek", :id => nil})
        actor1 = Actor.new({:name => "Brad Pitt", :id => nil})
        movie.save()
        actor.save()
        actor1.save()
        movie.update({:actor_ids => [actor.id, actor1.id]})
        expect(movie.actors()).to(eq([actor,actor1]))
      end
    end

    describe("#delete") do
      it("lets you delete a movie from the database") do
        movie = Movie.new({:name => "Oceans Eleven", :id => nil})
        movie.save()
        movie2 = Movie.new({:name => "Oceans Twelve", :id => nil})
        movie2.save()
        movie.delete()
        expect(Movie.all()).to(eq([movie2]))
      end
    end
  end

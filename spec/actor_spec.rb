require "rspec"
require "movie"
require "pg"

DB = PG.connect({:dbname => 'movie_database_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM movies *;')
  end
end

  describe(Actor) do


    describe(".all") do
      it("starts off with no movies") do
        expect(Actor.all()).to(eq([]))
      end
    end

    describe(".find") do
      it("returns a movie by its ID number") do
        test_movie = Actor.new({:name => "Oceans Eleven", :id => nil})
        test_movie.save()
        test_movie2 = Actor.new({:name => "Oceans twelve", :id => nil})
        test_movie2.save()
        expect(Actor.find(test_movie2.id())).to(eq(test_movie2))
      end
    end

    describe("#==") do
      it("is the same movie if it has the same name and id") do
        movie = Actor.new({:name => "Oceans Eleven", :id => nil})
        movie2 = Actor.new({:name => "Oceans Eleven", :id => nil})
        expect(movie).to(eq(movie2))
      end
    end

    describe("#update") do
      it("lets you update movies in the database") do
        movie = Actor.new({:name => "Oceans Eleven", :id => nil})
        movie.save()
        movie.update({:name => "Oceans Twelve"})
        expect(movie.name()).to(eq("Oceans Twelve"))
      end
    end

    describe("#delete") do
      it("lets you delete a movie from the database") do
        movie = Actor.new({:name => "Oceans Eleven", :id => nil})
        movie.save()
        movie2 = Actor.new({:name => "Oceans Twelve", :id => nil})
        movie2.save()
        movie.delete()
        expect(Actor.all()).to(eq([movie2]))
      end
    end
  end

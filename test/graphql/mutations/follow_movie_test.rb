require "test_helper"

class Mutations::FollowMovieTest < ActiveSupport::TestCase
 def setup
   @user = users(:user_one)
   @movie = movies(:movie_one)

   @mutation_string = <<~GRAPHQL
     mutation($movieId: ID!) {
       followMovie(input: { movieId: $movieId }) {
         success
         movie {
           id
           title
         }
         errors
       }
     }
   GRAPHQL
 end

 test "unauthenticated user cannot follow movies" do
   result = MovieApiSchema.execute(
     @mutation_string,
     variables: { movieId: @movie.id }
   )

   assert_not result["data"]["followMovie"]["success"]
   assert_includes result["data"]["followMovie"]["errors"], "User is not authenticated"
 end

 test "cannot follow non-existent movie" do
   result = MovieApiSchema.execute(
     @mutation_string,
     context: { current_user: @user },
     variables: { movieId: "nonexistent" }
   )

   assert_not result["data"]["followMovie"]["success"]
   assert_includes result["data"]["followMovie"]["errors"], "Movie not found"
 end

 test "cannot follow the same movie twice" do
   @user.followed_movies.delete(@movie) if @user.follows?(@movie)
   @user.followed_movies << @movie

   result = MovieApiSchema.execute(
     @mutation_string,
     context: { current_user: @user },
     variables: { movieId: @movie.id }
   )

   assert_not result["data"]["followMovie"]["success"]
   assert_includes result["data"]["followMovie"]["errors"], "Already following this movie"
 end

 test "can follow a movie successfully" do
   @user.followed_movies.delete(@movie) if @user.follows?(@movie)

   result = MovieApiSchema.execute(
     @mutation_string,
     context: { current_user: @user },
     variables: { movieId: @movie.id }
   )

   assert result["data"]["followMovie"]["success"]
   assert_equal @movie.id.to_s, result["data"]["followMovie"]["movie"]["id"]
   assert_empty result["data"]["followMovie"]["errors"]
 end
end

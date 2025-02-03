require "test_helper"

class Mutations::UnfollowMovieTest < ActiveSupport::TestCase
 def setup
   @user = users(:user_one)
   @movie = movies(:movie_one)

   @mutation_string = <<~GRAPHQL
     mutation($movieId: ID!) {
       unfollowMovie(input: { movieId: $movieId }) {
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

 test "unauthenticated user cannot unfollow movies" do
   result = MovieApiSchema.execute(
     @mutation_string,
     variables: { movieId: @movie.id }
   )

   assert_not result["data"]["unfollowMovie"]["success"]
   assert_includes result["data"]["unfollowMovie"]["errors"], "User is not authenticated"
 end

 test "cannot unfollow non-existent movie" do
   result = MovieApiSchema.execute(
     @mutation_string,
     context: { current_user: @user },
     variables: { movieId: "nonexistent" }
   )

   assert_not result["data"]["unfollowMovie"]["success"]
   assert_includes result["data"]["unfollowMovie"]["errors"], "Movie not found"
 end

test "cannot unfollow a movie that is not being followed" do
  @user.followed_movies.delete(@movie) if @user.follows?(@movie)

  result = MovieApiSchema.execute(
    @mutation_string,
    context: { current_user: @user },
    variables: { movieId: @movie.id }
  )

  assert_not result["data"]["unfollowMovie"]["success"]
  assert_equal [ "Not following this movie" ], result["data"]["unfollowMovie"]["errors"]
end

 test "can unfollow a movie successfully" do
   # First follow the movie
   @user.followed_movies << @movie unless @user.follows?(@movie)

   result = MovieApiSchema.execute(
     @mutation_string,
     context: { current_user: @user },
     variables: { movieId: @movie.id }
   )

   assert result["data"]["unfollowMovie"]["success"]
   assert_equal @movie.id.to_s, result["data"]["unfollowMovie"]["movie"]["id"]
   assert_empty result["data"]["unfollowMovie"]["errors"]
   assert_not @user.follows?(@movie)
 end
end

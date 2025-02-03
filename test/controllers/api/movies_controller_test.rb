require "test_helper"

class Api::MoviesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_one)
    @movie = movies(:movie_one)
    @movie_two = movies(:movie_two)
    @headers = auth_headers(generate_token(@user.id))
  end

  test "should get index" do
    get api_movies_path, headers: @headers, as: :json

    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal Movie.count, response_data["movies"].count
  end

  test "should show movie" do
    get api_movie_path(@movie), headers: @headers, as: :json

    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal @movie.title, response_data["title"]
  end

 test "should create movie" do
    assert_difference("Movie.count") do
      post api_movies_path,
        params: { movie: {
          title: "New Movie",
          description: "New Description",
          genre: "Action",
          director: "New Director",
          release_date: "2025-01-30"
        } }.to_json,
        headers: @headers
    end

    assert_response :created
  end

  test "should not create movie with invalid data" do
    assert_no_difference("Movie.count") do
      post api_movies_path,
        params: { movie: {
          title: nil,
          description: "New Description",
          genre: "Action",
          director: "New Director",
          release_date: "2025-01-30"
        } }.to_json,
        headers: @headers
    end

    assert_response :unprocessable_entity
  end

  test "should update movie" do
    patch api_movie_path(@movie),
      params: { movie: { title: "Updated Title" } }.to_json,
      headers: @headers

    assert_response :success
    @movie.reload
    assert_equal "Updated Title", @movie.title
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete api_movie_path(@movie), headers: @headers
    end

    assert_response :no_content
  end

  test "should follow movie" do
    assert_difference("@user.follows.count", 1) do
      post follow_api_movie_path(@movie_two.id), headers: @headers, as: :json
    end
    assert_response :success
    assert_equal "Movie followed successfully", JSON.parse(response.body)["message"]
  end

  test "should unfollow movie" do
    assert_difference("@user.follows.count", -1) do
      delete unfollow_api_movie_path(@movie.id), headers: @headers, as: :json
    end
    assert_response :success
    assert_equal "Movie unfollowed successfully", JSON.parse(response.body)["message"]
  end

  test "should require authentication" do
    get api_movies_path, as: :json
    assert_response :unauthorized
  end

  test "should filter movies by genre" do
    drama_movies = Movie.by_genre("Drama")

    get api_movies_path(genre: "Drama"), headers: @headers, as: :json

    response_data = JSON.parse(response.body)

    assert_response :success
    assert_equal drama_movies.count, response_data["movies"].count,
    "Number of returned movies should match database count for Drama genre"
  end

  test "should filter movies by director" do
    frank_movies = Movie.by_director("Frank Darabont")

    get api_movies_path(director: "Frank Darabont"), headers: @headers, as: :json

    response_data = JSON.parse(response.body)

    assert_response :success
    assert_equal frank_movies.count, response_data["movies"].count,
    "Number of returned movies should match database count for Frank Darabont director"
  end

  test "should filter movies by release date" do
    release_date = "1994-09-23"
    release_date_movies = Movie.by_release_date(release_date)

    get api_movies_path(date: release_date), headers: @headers, as: :json

    response_data = JSON.parse(response.body)

    assert_response :success
    assert_equal release_date_movies.count, response_data["movies"].count,
    "Number of returned movies should match database count for 1994-09-23 release date"
  end

  test "should cache index results" do
    # First request (should hit the database and cache the result)
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    first_response = response.body

    # Second request (should return the cached result)
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    second_response = response.body

    assert_equal first_response, second_response, "Cached response should match the first response"

    # Invalidate cache by creating a new movie
    post api_movies_path,
      params: { movie: {
        title: "New Movie",
        description: "New Description",
        genre: "Action",
        director: "New Director",
        release_date: "2025-01-30"
      } }.to_json,
      headers: @headers

    # Third request (should hit the database again due to cache invalidation)
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    third_response = response.body

    assert_not_equal second_response, third_response, "Cache should have been invalidated"
  end

  test "should cache show results" do
    get api_movie_path(@movie.id), headers: @headers, as: :json
    assert_response :success
    first_response = response.body

    get api_movie_path(@movie.id), headers: @headers, as: :json
    assert_response :success
    second_response = response.body

    assert_equal first_response, second_response, "Cached response should match the first response"

    # Invalidate cache by updating the movie
    patch api_movie_path(@movie.id),
      params: { movie: { title: "Updated Title" } }.to_json,
      headers: @headers
    get api_movie_path(@movie.id), headers: @headers, as: :json
    assert_response :success
    third_response = response.body

    assert_not_equal second_response, third_response, "Cache should have been invalidated"
  end

  test "should invalidate cache on create" do
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    first_response = response.body

    assert_difference("Movie.count") do
      post api_movies_path,
        params: { movie: {
          title: "New Movie",
          description: "New Description",
          genre: "Action",
          director: "New Director",
          release_date: "2025-01-30"
        } }.to_json,
        headers: @headers
    end

    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    second_response = response.body

    assert_not_equal first_response, second_response, "Cache should have been invalidated"
  end

  test "should invalidate cache on update" do
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    first_response = response.body

    patch api_movie_path(@movie.id),
      params: { movie: { title: "Updated Title" } }.to_json,
      headers: @headers

    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    second_response = response.body

    assert_not_equal first_response, second_response, "Cache should have been invalidated"
  end

  test "should invalidate cache on destroy" do
    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    first_response = response.body

    assert_difference("Movie.count", -1) do
      delete api_movie_path(@movie.id), headers: @headers
    end

    get api_movies_path, headers: @headers, as: :json
    assert_response :success
    second_response = response.body

    assert_not_equal first_response, second_response, "Cache should have been invalidated"
  end
end

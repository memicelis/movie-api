require "test_helper"

class MovieTest < ActiveSupport::TestCase
  def setup
    @movie = movies(:movie_one)
  end

  test "should be valid" do
    assert @movie.valid?
  end

  test "title should be present" do
    @movie.title = nil
    assert_not @movie.valid?
  end

  test "should generate slug" do
    movie = Movie.create(
      title: "Test Movie",
      description: "Test Description",
      director: "Test Director",
      release_date: Date.today,
      genre: "Drama"
    )
    assert_equal "test-movie", movie.slug
  end

  test "should generate new slug when title changes" do
    @movie.title = "New Title"
    @movie.save

    assert_equal "new-title", @movie.slug
  end

  test "should filter by genre" do
    assert_includes Movie.by_genre("Drama"), movies(:movie_one)
    assert_not_includes Movie.by_genre("Drama"), movies(:movie_two)
  end

  test "should filter by director" do
    assert_includes Movie.by_director("Frank Darabont"), movies(:movie_one)
    assert_not_includes Movie.by_director("Frank Darabont"), movies(:movie_two)
  end

  test "should filter by release date" do
    assert_includes Movie.by_release_date("1994-09-23"), movies(:movie_one)
    assert_not_includes Movie.by_release_date("1994-09-23"), movies(:movie_two)
  end

  test "should have many follows" do
    assert_respond_to @movie, :follows
  end

  test "should have many followers" do
    assert_respond_to @movie, :followers
  end
end

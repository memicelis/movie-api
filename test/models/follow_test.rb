require "test_helper"

class FollowTest < ActiveSupport::TestCase
  def setup
    @follow = follows(:follow_one)
    @user = users(:user_one)
    @movie = movies(:movie_one)
  end

  test "should be valid" do
    assert @follow.valid?
  end

  test "should require user" do
    @follow.user = nil
    assert_not @follow.valid?
  end

  test "should require movie" do
    @follow.movie = nil
    assert_not @follow.valid?
  end

  test "should enforce unique user-movie combination" do
    duplicate_follow = Follow.new(
      user: @follow.user,
      movie: @follow.movie
    )
    assert_not duplicate_follow.valid?
  end

  test "should belong to a movie" do
    assert_respond_to @follow, :movie
  end
  test "should allow same user to follow different movies" do
    new_follow = Follow.new(
      user: @user,
      movie: movies(:movie_two)
    )
    assert new_follow.valid?
  end

  test "should allow same movie to be followed by different users" do
    new_follow = Follow.new(
      user: users(:user_two),
      movie: @movie
    )
    assert new_follow.valid?
  end
end

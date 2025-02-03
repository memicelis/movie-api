require "test_helper"

class MoviePolicyTest < ActiveSupport::TestCase
  def setup
    @admin = users(:user_one)
    @moderator = users(:user_two)
    @user = users(:user_three)
    @movie = movies(:movie_one)
  end

  def test_show
    assert MoviePolicy.new(@admin, @movie).show?
    assert MoviePolicy.new(@moderator, @movie).show?
    assert MoviePolicy.new(@user, @movie).show?
  end

  def test_create
    assert MoviePolicy.new(@admin, @movie).create?
    assert MoviePolicy.new(@moderator, @movie).create?
    assert_not MoviePolicy.new(@user, @movie).create?
  end

  def test_update
    assert MoviePolicy.new(@admin, @movie).update?
    assert MoviePolicy.new(@moderator, @movie).update?
  end

  def test_destroy
    assert MoviePolicy.new(@admin, @movie).destroy?
    assert_not MoviePolicy.new(@moderator, @movie).destroy?
    assert_not MoviePolicy.new(@user, @movie).destroy?
  end
end

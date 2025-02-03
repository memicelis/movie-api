require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "username should be unique" do
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?
  end

  test "should authenticate with correct password" do
    assert @user.authenticate("password")
  end

  test "should not authenticate with incorrect password" do
    assert_not @user.authenticate("wrong_password")
  end

  test "should have many follows" do
    assert_respond_to @user, :follows
  end

  test "should have many followed movies" do
    assert_respond_to @user, :followed_movies
  end
end

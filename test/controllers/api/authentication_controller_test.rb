require "test_helper"

class Api::AuthenticationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_one)
  end

  test "should authenticate user" do
    post api_login_path, params: { email: @user.email, password: "password" }, as: :json

    assert_response :success
    response_data = JSON.parse(response.body)
    assert_not_nil response_data["token"]
    assert_not_nil response_data["exp"]
    assert_not_nil response_data["user"]
  end

  test "should not authenticate user with invalid password" do
    post api_login_path, params: { email: @user.email, password: "wrong_password" }, as: :json

    assert_response :unauthorized
    response_data = JSON.parse(response.body)
    assert_equal [ "Invalid email or password" ], response_data["errors"]
  end

  test "should not authenticate user with invalid email" do
    post api_login_path, params: { email: "wrong@email.com", password: "password" }, as: :json

    assert_response :unauthorized
    response_data = JSON.parse(response.body)
    assert_equal [ "Invalid email or password" ], response_data["errors"]
  end
end

require "test_helper"

class Api::GraphqlControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @query = "{ movies { id title } }"
    @variables = {}
    @headers = auth_headers(generate_token(@user.id))
  end

  test "should get successful response with valid query" do
    post api_graphql_url, params: { query: @query, variables: @variables }.to_json, headers: @headers
    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response.key?("data")
  end

  test "should return error with invalid query" do
    invalid_query = "invalid query"
    post api_graphql_url, params: { query: invalid_query, variables: @variables }.to_json, headers: @headers

    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response.key?("errors")
  end

  test "should return unauthorized without token" do
    post api_graphql_url, params: { query: @query, variables: @variables }.to_json

    assert_response :unauthorized
  end

  test "should return error with missing query" do
    post api_graphql_url, params: { variables: @variables }.to_json, headers: @headers

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "No query string was present", json_response["errors"].first["message"]
  end

  test "should return error with invalid variables" do
    invalid_variables = "invalid variables"
    post api_graphql_url, params: { query: @query, variables: invalid_variables }.to_json, headers: @headers
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response.key?("errors")
  end

  test "should return error with expired token" do
    expired_headers = auth_headers(generate_token(@user.id, 1.hour.ago))

    post api_graphql_url,
      params: { query: @query }.to_json,
      headers: expired_headers

    assert_response :unauthorized
  end
end

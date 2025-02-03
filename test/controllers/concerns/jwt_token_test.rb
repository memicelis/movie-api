require "test_helper"
require "jwt"
require_relative "../../../app/controllers/concerns/jwt_token"

class JwtTokenTest < ActiveSupport::TestCase
  include JwtToken

  def setup
    @payload = { user_id: 1 }
    @token = jwt_encode(@payload)
  end

  test "should encode a JWT token" do
    assert_not_nil @token
  end

  test "should decode a JWT token" do
    decoded_payload = jwt_decode(@token)
    assert_equal @payload[:user_id], decoded_payload[:user_id]
  end

  test "should raise error for expired token" do
    expired_token = jwt_encode(@payload, exp: 1.second.ago)
    assert_raises(JWT::ExpiredSignature) { jwt_decode(expired_token) }
  end

  test "should raise error for invalid token" do
    assert_raises(JWT::DecodeError) { jwt_decode("invalid_token") }
  end
end

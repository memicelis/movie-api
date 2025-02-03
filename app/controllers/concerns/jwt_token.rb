require "jwt"

module JwtToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def jwt_encode(payload, exp: 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY).first
    HashWithIndifferentAccess.new decoded
  rescue JWT::ExpiredSignature
    raise JWT::ExpiredSignature, "Token has expired"
  rescue JWT::DecodeError
    raise JWT::DecodeError, "Invalid token"
  end
end

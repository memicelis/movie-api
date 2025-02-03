module Authenticable
  extend ActiveSupport::Concern
  include JwtToken

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ "User not found" ] }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: [ "Invalid token" ] }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { errors: [ "Token has expired" ] }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end

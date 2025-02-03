class Api::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      token = jwt_encode(payload)
      render json: { token: token, exp: 7.days.from_now.to_i, user: user.as_json(except: :password_digest) }
    else
      render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
    end
  end
end

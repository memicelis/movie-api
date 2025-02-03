module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      return reject_unauthorized_connection unless token

      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
        user_id = decoded_token[0]["user_id"]
        verified_user = User.find_by(id: user_id)

        verified_user || reject_unauthorized_connection
      rescue JWT::DecodeError
        reject_unauthorized_connection
      end
    end
  end
end

require "simplecov"
SimpleCov.start "rails" do
  minimum_coverage 70
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "json"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: 1)

    # Setup all fixtures
    fixtures :all

    # Helper method to generate tokens for testing
    def generate_token(user_id, exp = 7.days.from_now)
      JWT.encode(
        {
          user_id: user_id,
          exp: exp.to_i
        },
        Rails.application.credentials.secret_key_base
      )
    end
  end
end

class ActionDispatch::IntegrationTest
  def auth_headers(token)
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end
end

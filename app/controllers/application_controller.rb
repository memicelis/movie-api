class ApplicationController < ActionController::API
  include Authenticable
  include Pundit::Authorization

  before_action :authenticate_request, only: [ :login ]
end

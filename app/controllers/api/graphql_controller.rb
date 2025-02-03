# frozen_string_literal: true

class Api::GraphqlController < ApplicationController
  before_action :authenticate_request, only: [ :execute ]
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: current_user
    }

    result = MovieApiSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue JSON::ParserError => e
    render json: { errors: [ { message: "Invalid JSON format for variables" } ] }, status: :unprocessable_entity
  end

  private

  def token_auth?
    request.headers["Authorization"].present?
  end

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash, ActionController::Parameters
      variables_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  rescue JSON::ParserError
    raise JSON::ParserError, "Invalid JSON format for variables"
  end
end

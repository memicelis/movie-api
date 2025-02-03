# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :movies, [ Types::MovieType ], null: false

    field :movie, Types::MovieType, null: false do
      description "Get a movie by ID"
      argument :id, ID, required: true
    end

    def movies
      Movie.all
    end

    def movie(id:)
      Movie.find(id)
    end
  end
end

class Mutations::UnfollowMovie < Mutations::BaseMutation
  argument :movie_id, ID, required: true

  field :success, Boolean, null: false
  field :movie, Types::MovieType, null: true
  field :errors, [ String ], null: false

  def resolve(movie_id:)
    return { success: false, movie: nil, errors: [ "User is not authenticated" ] } unless context[:current_user]

    movie = Movie.find_by(id: movie_id)
    return { success: false, movie: nil, errors: [ "Movie not found" ] } unless movie

    if context[:current_user].follows?(movie)
        context[:current_user].followed_movies.delete(movie)
        {
          success: true,
          movie: movie,
          errors: []
        }
    else
        {
          success: false,
          movie: movie,
          errors: [ "Not following this movie" ]
        }
    end
  end
end

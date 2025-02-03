class Mutations::FollowMovie < Mutations::BaseMutation
  argument :movie_id, ID, required: true

  field :success, Boolean, null: false
  field :movie, Types::MovieType, null: true
  field :errors, [ String ], null: false

  def resolve(movie_id:)
    return { success: false, movie: nil, errors: [ "User is not authenticated" ] } unless context[:current_user]

    movie = Movie.find_by(id: movie_id)
    return { success: false, movie: nil, errors: [ "Movie not found" ] } unless movie

    if context[:current_user].follows?(movie)
      {
        success: false,
        movie: movie,
        errors: [ "Already following this movie" ]
      }
    else
      context[:current_user].followed_movies << movie
      {
        success: true,
        movie: movie,
        errors: []
      }
    end
  end
end

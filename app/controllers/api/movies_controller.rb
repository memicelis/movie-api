class Api::MoviesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_request
  before_action :set_movie, only: [ :show, :update, :destroy, :follow, :unfollow ]
  before_action -> { authorize @movie }, only: [ :show, :update, :destroy ]
  before_action -> { authorize Movie }, only: [ :create ]

  def index
    cache_key = "movies/#{cache_key_params}"
    @movies = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      movies = Movie.includes(:follows)
      movies = movies.by_genre(params[:genre]) if params[:genre].present?
      movies = movies.by_director(params[:director]) if params[:director].present?
      movies = movies.by_release_date(params[:date]) if params[:date].present?
      movies
    end

    @pagy, @movies = pagy(@movies, limit: params[:per_page] || 10)

    if stale?(etag: @movies, last_modified: @movies.maximum(:updated_at))
      render json: {
        movies: @movies,
        pagination: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count
        }
      }
    end
  end

def show
  # Include follow status in the response
  movie_json = @movie.as_json
  movie_json[:followed] = current_user.follows.exists?(movie_id: @movie.id)

  fresh_when @movie
  render json: movie_json
end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      Rails.cache.delete_matched("movies/*")
      render json: @movie, status: :created
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      Rails.cache.delete_matched("movies/*")
      render json: @movie
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    Rails.cache.delete("movies/#{@movie.id}")
    Rails.cache.delete_matched("movies/*")
    head :no_content
  end

def follow
  existing_follow = current_user.follows.find_by(movie_id: params[:id])

  if existing_follow
    render json: { message: "Movie already followed" }
  else
    follow = current_user.follows.build(movie_id: params[:id])

    if follow.save
      render json: { message: "Movie followed successfully" }
    else
      render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

def unfollow
  follow = current_user.follows.find_by(movie_id: params[:id])

  if follow&.destroy
    render json: { message: "Movie unfollowed successfully" }
  else
    render json: { errors: "Unable to unfollow movie" }, status: :unprocessable_entity
  end
end

  private

  def set_movie
    cache_key = "movies/#{params[:id]}"
    @movie = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Movie.friendly.find(params[:id])
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :genre, :director, :release_date)
  end

  def cache_key_params
    [
      params[:genre],
      params[:director],
      params[:date],
      params[:page],
      params[:per_page]
    ].compact.join("-")
  end
end

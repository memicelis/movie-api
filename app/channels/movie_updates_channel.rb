class MovieUpdatesChannel < ApplicationCable::Channel
  def subscribed
    current_user.followed_movies.each do |movie|
      stream_from "movie_#{movie.id}_updates"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end

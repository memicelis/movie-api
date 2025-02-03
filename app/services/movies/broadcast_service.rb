class Movies::BroadcastService
  def self.broadcast_update(movie)
    return if movie.saved_changes.except("updated_at").empty?

    ActionCable.server.broadcast(
      "movie_#{movie.id}_updates",
      {
        type: "movie_update",
        data: {
          id: movie.id,
          title: movie.title,
          changes: movie.saved_changes.except("updated_at")
        }
      }
    )
  end
end

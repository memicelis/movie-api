# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :follow_movie, mutation: Mutations::FollowMovie
    field :unfollow_movie, mutation: Mutations::UnfollowMovie
  end
end

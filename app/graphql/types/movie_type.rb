class Types::MovieType < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
  field :description, String, null: true
  field :genre, String, null: true
  field :director, String, null: true
  field :release_date, GraphQL::Types::ISO8601Date, null: true
  field :followers_count, Integer, null: false
  field :is_followed_by_current_user, Boolean, null: false

  def followers_count
    object.followers.count
  end

  def is_followed_by_current_user
    return false unless context[:current_user]
    object.followers.include?(context[:current_user])
  end
end

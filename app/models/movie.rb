class Movie < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  validates :title, presence: true

  scope :by_genre, ->(genre) { where(genre: genre)  if genre.present? }
  scope :by_director, ->(director) { where(director: director)  if director.present? }
  scope :by_release_date, ->(date) { where(release_date: date)  if date.present? }

  after_update_commit :broadcast_update

  def should_generate_new_friendly_id?
    title_changed?
  end

  private

  def broadcast_update
    ActionCable.server.broadcast(
      "movie_#{id}_updates",
      {
        type: "movie_update",
        data: {
          id: id,
          title: title,
          changes: saved_changes.except("updated_at")
        }
      }
    )
  end
end

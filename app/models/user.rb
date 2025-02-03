class User < ApplicationRecord
  has_secure_password

  enum :role, {
    user: 0,
    moderator: 1,
    admin: 2
  }



  has_many :follows, dependent: :destroy
  has_many :followed_movies, through: :follows, source: :movie

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  def follows?(movie)
    followed_movies.include?(movie)
  end
end

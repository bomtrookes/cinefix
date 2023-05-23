class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :ratings
  has_many :watchlists
  has_many :movies, through: :ratings

  def movie_ratings
    MovieRating.joins(rating: :movie).where(ratings: { user_id: self.id })
  end
end

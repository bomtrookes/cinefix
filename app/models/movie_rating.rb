class MovieRating < ApplicationRecord
  belongs_to :movie
  belongs_to :rating

  validates :movie_id, uniqueness: { scope: [:user_id, :rating_id], message: "has already been rated by this user" }
end

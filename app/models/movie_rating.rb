class MovieRating < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :rating

end

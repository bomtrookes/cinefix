class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :movie_ratings

  has_many :movies, through: :movie_ratings

end

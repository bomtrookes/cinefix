class Movie < ApplicationRecord

  has_many :movie_ratings
  has_many :ratings, through: :movie_ratings

  validates :title, presence: true
  validates :year, presence: true
  attribute :genres, :string, array: true


  def self.with_ratings(user)
    joins(:ratings).where("ratings.user_id = ? AND NOT rating IS NULL", user.id).distinct
  end


end

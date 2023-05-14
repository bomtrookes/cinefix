class Movie < ApplicationRecord

  has_many :movie_ratings

  validates :title, presence: true
  validates :year, presence: true
  validates :genre, presence: true

  def total_score
    sum = [:story, :acting, :dialog,
          :cinematography, :soundtrack,
          :style, :pacing, :originality,
          :characters, :enjoyment]
          .sum { |attr| ranking.try(attr) || 0 }
    sum.to_f / 10
  end

end

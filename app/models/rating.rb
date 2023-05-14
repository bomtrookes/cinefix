class Rating < ApplicationRecord
  has_many :movie_ratings

  validates :story,
  :acting,
  :dialog,
  :cinematography,
  :soundtrack,
  :style,
  :pacing,
  :originality,
  :characters,
  :enjoyment, presence: true,
  numericality: { only_integer: true,
                  greater_than_or_equal_to: 0,
                  less_than_or_equal_to: 10 }
end

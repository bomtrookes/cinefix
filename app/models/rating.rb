class Rating < ApplicationRecord

  belongs_to :user
  belongs_to :movie


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

  def total_score
    sum = story +
      acting +
      dialog +
      cinematography +
      soundtrack +
      style +
      pacing +
      originality +
      characters +
      enjoyment
    movie.update(rating: sum.to_f / 10)
  end
end

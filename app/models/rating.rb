class Rating < ApplicationRecord

  belongs_to :user

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
  validates :api_id, uniqueness: { scope: :user_id }

  def total_score
    sum = self.story +
      self.acting +
      self.dialog +
      self.cinematography +
      self.soundtrack +
      self.style +
      self.pacing +
      self.originality +
      self.characters +
      self.enjoyment

    if sum.to_f / 10 == 10.0
      return sum.to_i / 10
    else
      return (sum.to_f / 10).round(1)
    end
  end

end

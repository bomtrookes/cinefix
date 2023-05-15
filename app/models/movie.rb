class Movie < ApplicationRecord

  has_many :ratings

  validates :title, presence: true
  validates :year, presence: true


  def self.with_ratings(user)
    joins(:ratings).where("reviews.user_id = ? AND NOT rating IS NULL", user.id).distinct
  end

end

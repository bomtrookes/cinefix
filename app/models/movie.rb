class Movie < ApplicationRecord

  has_many :users

  accepts_nested_attributes_for :ratings

  validates :title, presence: true
  validates :year, presence: true
  attribute :genres, :string, array: true


  def self.with_ratings(user)
    joins(:ratings).where("ratings.user_id = ? AND NOT rating IS NULL", user.id).distinct
  end


end

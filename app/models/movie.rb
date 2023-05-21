class Movie < ApplicationRecord
  has_many :users

  validates :title, presence: true
  validates :year, presence: true
  attribute :genres, :string, array: true

end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :ratings
  has_many :watchlists
  has_many :movies, through: :ratings
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true

  has_many :received_follows, foreign_key: :followed_user_id, class_name: "Follow"
  has_many :followers, through: :received_follows, source: :follower
  has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"
  has_many :followings, through: :given_follows, source: :followed_user

  include PgSearch::Model
    pg_search_scope :search_users,
                    against: [ :username ],
                    using: {
                      tsearch: { prefix: true }
                    }

  # def movie_ratings
  #   MovieRating.joins(rating: :movie).where(ratings: { user_id: self.id })
  # end
end

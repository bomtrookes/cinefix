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

  include RatingsHelper

  def feed_activities
    followings = self.followings.includes(:ratings)
    ratings = Rating.where(user_id: followings.map(&:id)).order(created_at: :desc).includes(:user)
    ratings.map { |rating| { user: rating.user, rating: rating } }
  end


  include PgSearch::Model
    pg_search_scope :search_users,
                    against: [ :username ],
                    using: {
                      tsearch: { prefix: true }
                    }
end

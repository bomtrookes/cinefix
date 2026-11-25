class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { member: 0, admin: 1, demo: 2 }

  has_many :ratings
  has_many :watchlists
  has_many :watched_films
  has_many :movies, through: :ratings
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true
  validate :avatar_is_a_small_photo

  has_many :received_follows, foreign_key: :followed_user_id, class_name: "Follow"
  has_many :followers, through: :received_follows, source: :follower
  has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"
  has_many :followings, through: :given_follows, source: :followed_user

  include RatingsHelper

  # Safety net for any path that attaches a photo without AvatarUpload.
  def avatar_is_a_small_photo
    return unless attachment_changes["avatar"] && avatar.attached?

    errors.add(:avatar, "must be a JPG, PNG, WebP or HEIC photo") unless AvatarUpload::TYPES.include?(avatar.blob.content_type)
    errors.add(:avatar, "must be 10 MB or smaller") if avatar.blob.byte_size > AvatarUpload::MAX_BYTES
  end

  def rank
    Rank.for(ratings.size)
  end

  def feed_activities
    ratings = Rating.where(user_id: followings.select(:id)).order(created_at: :desc)
                    .includes(user: { avatar_attachment: :blob })
    ratings.map { |rating| { user: rating.user, rating: rating } }
  end


  include PgSearch::Model
    pg_search_scope :search_users,
                    against: [ :username ],
                    using: {
                      tsearch: { prefix: true }
                    }
end

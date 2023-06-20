class Activity < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :action, presence: true

  scope :feed_for_user, ->(user) { joins(user: :followers).where(follows: { follower_id: user.id }) }

end

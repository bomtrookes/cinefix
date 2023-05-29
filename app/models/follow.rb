class Follow < ApplicationRecord

  belongs_to :follower, foreign_key: :follower_id, class_name: "User"
  belongs_to :followed_user, foreign_key: :followed_user_id, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_user_id }
  validates :followed_user_id, uniqueness: { scope: :follower_id }

end

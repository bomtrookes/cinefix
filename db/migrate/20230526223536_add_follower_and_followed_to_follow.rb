class AddFollowerAndFollowedToFollow < ActiveRecord::Migration[7.0]
  def change
    add_column :follows, :follower_id, :integer
    add_column :follows, :followed_user_id, :integer
  end
end

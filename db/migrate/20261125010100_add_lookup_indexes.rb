# Most lookups are "this user's row for this film" or "who follows whom",
# and none of those columns were indexed together.
class AddLookupIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :ratings, [:user_id, :api_id]
    add_index :watchlists, [:user_id, :api_id]
    add_index :watched_films, [:user_id, :api_id]
    add_index :follows, [:follower_id, :followed_user_id]
    add_index :follows, :followed_user_id
  end
end

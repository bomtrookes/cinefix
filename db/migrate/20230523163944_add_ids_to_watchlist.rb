class AddIdsToWatchlist < ActiveRecord::Migration[7.0]
  def change
    add_reference :watchlists, :user, null: false, foreign_key: true
    add_column :watchlists, :api_id, :integer
  end
end

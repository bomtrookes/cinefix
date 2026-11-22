class WatchedFilm < ApplicationRecord
  belongs_to :user

  validates :api_id, uniqueness: { scope: :user_id }

  after_create :remove_from_watchlist

  private

  def remove_from_watchlist
    user.watchlists.where(api_id: api_id).destroy_all
  end
end

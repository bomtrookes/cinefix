class WatchlistsController < ApplicationController
  def index
    @watchlists = Watchlist.where(user_id: current_user.id)
  end
end

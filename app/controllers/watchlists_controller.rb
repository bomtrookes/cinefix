class WatchlistsController < ApplicationController

  def index
    @watchlists = Watchlist.where(user_id: current_user.id)
  end

  def create
    @watchlist = Watchlist.new(watchlist_params)
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :api_id)
  end
end

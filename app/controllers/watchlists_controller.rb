class WatchlistsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @user = User.find(params[:user_id])
    @watchlists = Watchlist.where(user_id: @user.id)
  end

  def create
    current_user.watchlists.create(api_id: params[:id])
    redirect_to movie_path(params[:id]), notice: "Added to your watchlist"
  end

  def destroy
    current_user.watchlists.find_by(api_id: params[:id])&.destroy
    redirect_to movie_path(params[:id]), notice: "Removed from your watchlist"
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :api_id)
  end
end

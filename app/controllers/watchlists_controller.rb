class WatchlistsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @watchlists = Watchlist.where(user_id: @user.id)
  end

  def create
    @watchlist = current_user.watchlists
    @movie = Tmdb::Movie.detail(params[:id])
    @watchlist = current_user.watchlists.build(api_id: params[:id])
    @watchlist.save
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Tmdb::Movie.detail(params[:id])
    @watchlist = Watchlist.find_by(api_id: params[:id])
    @watchlist.destroy
    redirect_to movie_path(@movie)
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :api_id)
  end
end

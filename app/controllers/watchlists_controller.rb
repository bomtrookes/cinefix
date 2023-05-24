class WatchlistsController < ApplicationController

  def index
    @watchlists = Watchlist.where(user_id: current_user.id)
  end

  def create
    @watchlist = current_user.watchlist
    @movie = Tmdb::Movie.detail(params[:id])

    if @watchlist.movies.include?(@movie)
      flash[:notice] = "Movie is already in your watchlist"
    else
      @watchlist.movies << @movie
      flash[:success] = "Movie added to watchlist"
    end
    redirect_to root_path
  end

  def destroy
    # watchlists??
    @watchlist = current_user.watchlists
    @movie = Tmdb::Movie.detail(params[:id])

    if @watchlist.movies.include?(@movie)
      @watchlist.movies.delete(@movie)
      flash[:success] = "Movie removed from watchlist"
    else
      flash[:notice] = "Movie is not in your watchlist"
    end
    redirect_to root_path
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :api_id)
  end
end

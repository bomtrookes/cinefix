class WatchlistsController < ApplicationController

  def index
    @watchlists = Watchlist.where(user_id: current_user.id)
  end

  def create
    @watchlist = current_user.watchlists
    @movie = Tmdb::Movie.detail(params[:id])
    @watchlist = current_user.watchlists.build(api_id: params[:id])
    @watchlist.save

    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)

  end

  def destroy
    @watchlist = Watchlist.find_by(api_id: params[:id])
    @watchlist.destroy

    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:user_id, :api_id)
  end
end

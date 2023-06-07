class WatchedFilmsController < ApplicationController

  # def new
  #   @watched_film = WatchedFilm.new
  # end

  # def create
  #   @watched_film = WatchedFilm.new(watched_film_params)
  #   if @watched_film.save

  #     redirect_to user_path(current_user)
  #   else
  #     render :new
  #   end
  # end

  def mark_as_watched
    movie = Watchlist.where(user_id: params[:id], api_id: params[:api_id]).first
    watched_movie = WatchedFilm.new(api_id: params[:id], user_id: current_user.id, watched: true)

    if watched_movie.save
      movie.destroy
      redirect_to watchlist_path, notice: "Movie marked as watched!"
    else
      redirect_to watchlist_path, alert: "Failed to mark movie as watched."
    end
  end

end

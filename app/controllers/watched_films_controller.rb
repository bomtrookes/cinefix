class WatchedFilmsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @watched_films = WatchedFilm.where(user_id: @user.id)
  end

  def watched
    @movie = Tmdb::Movie.detail(params[:api_id])
    @watched = current_user.watched_films.build(api_id: @movie.id, watched: true)
    @watched.save
    redirect_to movie_path(@movie.id)
  end

  def unwatch
    @movie = Tmdb::Movie.detail(params[:api_id])
    @watched = WatchedFilm.find_by(api_id: @movie.id)

    if @watched
      @watched.destroy!
      redirect_to movie_path(@movie)
    else
      # Handle the case when the watched film is not found
      redirect_to movie_path(@movie), alert: "Film not found in watched list."
    end
  end

end

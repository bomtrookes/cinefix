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
    x
  end

end

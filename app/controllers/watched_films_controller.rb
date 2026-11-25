class WatchedFilmsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @user = User.find(params[:user_id])
    @watched_films = WatchedFilm.where(user_id: @user.id).order(created_at: :desc).to_a
    @films = FilmDetail.for(@watched_films.map(&:api_id))
    @scores = @user.ratings.where(api_id: @watched_films.map(&:api_id))
                   .to_h { |rating| [rating.api_id, rating.total_score] }
  end

  def watched
    current_user.watched_films.create(api_id: params[:api_id], watched: true)
    redirect_to movie_path(params[:api_id]), notice: "Marked as watched"
  end

  def unwatch
    current_user.watched_films.find_by(api_id: params[:api_id])&.destroy
    redirect_to movie_path(params[:api_id]), notice: "Removed from watched"
  end

end

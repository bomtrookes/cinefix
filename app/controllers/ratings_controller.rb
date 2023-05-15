class RatingsController < ApplicationController
  before_action :set_user

  def index
    @user_ratings = Rating.where(user_id: current_user.id)
    @movie_ratings = @user_ratings.map { |rating| rating.movie }
  end

  def new
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new(rating_params)
    @rating.user_id = current_user.id
    if @rating.save
      @movie.update!(rating: @rating.total_score)
      redirect_to movie_ratings_path()
    else
      render :new
    end
  end


  private

  def rating_params
    params.require(:rating)
      .permit(
        :story, :acting, :dialog,
        :cinematography, :soundtrack,
        :style, :pacing, :originality,
        :characters, :enjoyment, :movie_id, :user_id)
  end

  def set_user
    @user = current_user
  end

end

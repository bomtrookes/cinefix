class RatingsController < ApplicationController
  before_action :set_user

  # def index
  #   @user_ratings = Rating.where(user_id: current_user.id)
  #   @movie_ratings = @user_ratings.map { |rating| rating.movie }
  # end

  def index
    @movie_ratings = current_user.ratings.map do |rating|
      {
        movie: rating.movie,
        user_rating: rating.total_score.to_f
      }
    end
  end


  def new
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new
    @movie_rating = MovieRating.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new(rating_params)
    @rating.user_id = current_user.id

    if @rating.save
      @movie_rating = MovieRating.create!(
        movie_id: @movie.id,
        rating_id: @rating.id,
        user_id: current_user.id,
        user_rating: @rating.total_score.to_f
      )
      # redirect_to movie_ratings_path
      redirect_to ratings_path
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

  def movie_rating_params
    params.require(:movie_rating).permit(:user_rating)
  end

  def set_user
    @user = current_user
  end

end

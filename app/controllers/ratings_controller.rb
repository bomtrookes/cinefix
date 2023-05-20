class RatingsController < ApplicationController
  before_action :set_user

  def index
    @ratings = Rating.all
    @movie_ids = @ratings.pluck(:api_id)
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

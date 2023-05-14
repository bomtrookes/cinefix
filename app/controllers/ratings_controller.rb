class RatingsController < ApplicationController

  def new
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @rating = current_user.ratings.build(rating_params)
    @rating.movie = @movie
    @movie.rating = @movie.ratings.total_rating
    if @rating.save
      redirect_to movie_path(@movie)
    else
      render 'new'
    end
  end


  private

  def rating_params
    params.require(:rating)
      .permit(
        :story, :acting, :dialog,
        :cinematography, :soundtrack,
        :style, :pacing, :originality,
        :characters, :enjoyment)
  end

end

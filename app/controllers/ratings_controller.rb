class RatingsController < ApplicationController
  before_action :set_user, only: :create
  before_action :authenticate_user!, only: [:new, :create, :index]

  def index
    @ratings = Rating.where(user_id: current_user).sort_by { |r| -r.total_score }
    # @movie_ids = @ratings.pluck(:api_id)
  end


  def new
    @movie = Tmdb::Movie.detail(params[:api_id])
    @rating = Rating.new
  end

  def create
    @movie = Tmdb::Movie.detail(params[:rating][:api_id])
    @rating = Rating.new(rating_params)
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
        :characters, :enjoyment, :api_id, :user_id)
  end

  def set_user
    @user = current_user
  end

end

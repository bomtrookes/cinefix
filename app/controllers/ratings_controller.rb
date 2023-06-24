class RatingsController < ApplicationController
  before_action :set_user, only: :show
  before_action :authenticate_user!, only: [:new, :create, :index]

  def new
    @movie = Tmdb::Movie.detail(params[:api_id])
    @rating = Rating.new
  end

  def create
    @movie = Tmdb::Movie.detail(params[:rating][:api_id])
    @rating = Rating.new(rating_params)
    if @rating.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def show
    @movie = Tmdb::Movie.detail(params[:id])
    @rating = Rating.find(@movie.id)
    @default = "https://res.cloudinary.com/dzxuvey8d/image/upload/v1660399373/default-user_cdb0ks.jpg"

  end

  def edit
    @user = current_user
    @movie = Tmdb::Movie.detail(params[:id])
    @rating = @user.ratings.where(api_id: params[:id]).first
  end

  def update
    @movie = Tmdb::Movie.detail(params[:id])
    @rating = Rating.find(@movie.id)
    if @rating.update(rating_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @rating = current_user.ratings.where(api_id: params[:id]).first
    @rating.destroy
    redirect_to user_path(current_user)
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
    if params[:user_id] == current_user.id
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
  end

end

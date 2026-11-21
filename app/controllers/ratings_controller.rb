class RatingsController < ApplicationController
  before_action :set_user, only: :show
  before_action :authenticate_user!, only: [:new, :create, :index, :edit, :update]

  def new
    @movie = Tmdb::Movie.detail(params[:api_id])
    @rating = Rating.new
  end

  def create
    @movie = Tmdb::Movie.detail(params[:rating][:api_id])
    @rating = current_user.ratings.new(rating_params)
    if @rating.save
      redirect_to user_path(current_user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @rating = @user.ratings.find(params[:id])
    @default = helpers.asset_path("default-user.jpg")
  end

  def edit
    @user = current_user
    @movie = Tmdb::Movie.detail(params[:id])
    @rating = @user.ratings.where(api_id: params[:id]).first
  end

  def update
    @rating = current_user.ratings.find(params[:id])
    @movie  = Tmdb::Movie.detail(@rating.api_id)

    if @rating.update(rating_params)
      redirect_to movie_path(@rating.api_id), notice: "Rating updated"
    else
      render :edit, status: :unprocessable_entity
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
        :characters, :enjoyment, :api_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end

class RatingsController < ApplicationController
  before_action :set_user, only: :create
  before_action :authenticate_user!, only: [:new, :create, :index]

  def index
    @ratings = Rating.where(user_id: current_user).sort_by { |r| -r.total_score }
    @recent = @ratings.sort_by { |r| -r.created_at.to_i }.reverse
  end


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
    @user = current_user
  end

end

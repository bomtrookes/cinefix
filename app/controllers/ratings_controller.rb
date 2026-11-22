class RatingsController < ApplicationController
  before_action :set_user, only: :show
  before_action :authenticate_user!, only: [:new, :create, :index, :edit, :update, :destroy]

  def new
    @movie = Tmdb::Movie.detail(params[:api_id])
    existing = current_user.ratings.find_by(api_id: @movie.id)
    return redirect_to edit_rating_path(@movie.id) if existing

    @rating = current_user.ratings.new(api_id: @movie.id, film_type: suggested_film_type(@movie))
  end

  def create
    @movie = Tmdb::Movie.detail(params[:rating][:api_id])
    @rating = current_user.ratings.new(rating_params)
    if @rating.save
      redirect_to movie_path(@rating.api_id), notice: "Rating saved and marked as watched"
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
    @rating = @user.ratings.find_by(api_id: params[:id])
    redirect_to new_rating_path(api_id: params[:id]) unless @rating
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
    @rating = current_user.ratings.find_by(api_id: params[:id])
    @rating&.destroy
    redirect_to user_path(current_user), notice: "Rating deleted"
  end

  private

  def rating_params
    params.require(:rating)
      .permit(
        :story, :acting, :dialog,
        :cinematography, :soundtrack,
        :style, :pacing, :originality,
        :characters, :enjoyment, :api_id,
        :review, :spoilers, :film_type)
      .tap do |permitted|
        # An N/A category arrives as an empty string; store it as nil
        RatingCategories::FIELDS.each do |field|
          permitted[field] = nil if permitted.key?(field) && permitted[field].blank?
        end
      end
  end

  def suggested_film_type(movie)
    genre_ids = Array(movie.genres).map { |genre| genre.id }
    genre_ids.include?(RatingCategories::DOCUMENTARY_GENRE_ID) ? "documentary" : "feature"
  end

  def set_user
    @user = User.find(params[:user_id])
  end

end

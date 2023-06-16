class MoviesController < ApplicationController

  def index

    if params[:query].present?
     query = params[:query].presence || " "
     @movies = Tmdb::Search.movie("#{query}")["results"]
     @people = Tmdb::Search.person("#{query}")["results"]
     @users = User.search_users("#{query}")
    else
      @movies = Tmdb::Movie.popular["results"].sort_by { |movie| movie.popularity }.reverse
      @people = []
      @users = []
    end
    @default = "https://res.cloudinary.com/dzxuvey8d/image/upload/v1660399373/default-user_cdb0ks.jpg"
 end

 def show
  @user = current_user
  @rating = @user.ratings.where(api_id: params[:id]).sort_by { |r| -r.total_score }.first
  @watchlist = Watchlist.new
  @movie = Tmdb::Movie.detail(params[:id])

  @tmdb_cast = Tmdb::Movie.cast(params[:id])
  @tmdb_crew = Tmdb::Movie.crew(params[:id])

  @tmdb_similar = Tmdb::Movie.similar(params[:id])["results"]
  @tmdb_recommend = Tmdb::Movie.recommendations(params[:id])["results"]
  # @rating = Rating.where(user_id: current_user).sort_by { |r| -r.total_score }
 end

  private

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :poster_url)
  end

end

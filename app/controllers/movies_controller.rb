class MoviesController < ApplicationController

  def home
    @movies = Tmdb::Movie.popular["results"]
    # @top_rated = Tmdb::Movie.top_rated["results"]
    # @upcoming = Tmdb::Movie.upcoming["results"]
    # @now_playing = Tmdb::Movie.now_playing["results"]
  end

  def index
    if params[:query].present?
     query = params[:query].presence || " "
     @movies = Tmdb::Search.movie("#{query}")["results"]
   else
     @movies = Tmdb::Movie.popular["results"]
   end
 end

 def show
  @user = current_user
  @watchlist = Watchlist.new
  @movie = Tmdb::Movie.detail(params[:id])

   @tmdb_cast = Tmdb::Movie.cast(params[:id])
   @tmdb_crew = Tmdb::Movie.crew(params[:id])

   @tmdb_similar = Tmdb::Movie.similar(params[:id])["results"]
   @tmdb_recommend = Tmdb::Movie.recommendations(params[:id])["results"]
 end

  private

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :poster_url)
  end

end

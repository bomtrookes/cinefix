class MoviesController < ApplicationController

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
   @movie = Tmdb::Movie.detail(params[:id])

   @tmdb_cast = Tmdb::Movie.cast(params[:id])
   @tmdb_crew = Tmdb::Movie.crew(params[:id])

   @tmdb_similar = Tmdb::Movie.similar(params[:id])["results"]
   @tmdb_recommend = Tmdb::Movie.recommendations(params[:id])["results"]
 end

  # def create
  #   @movie = Movie.find_or_initialize_by(api_id: params[:movie][:api_id])
  #   @movie.assign_attributes(movie_params)
  #   if @movie.save
  #     redirect_to new_movie_rating_path(@movie)
  #   else
  #     render 'show'
  #   end
  # end

  private

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :poster_url)
  end

end

class MoviesController < ApplicationController

  def index
     if params[:query].present?
      query = params[:query].presence || " "
      response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=#{ENV['API_KEY']}&query=#{query}")
      @movies = response.parsed_response
    else
      response = HTTParty.get("https://api.themoviedb.org/3/movie/popular?api_key=#{ENV['API_KEY']}")
      @movies = response.parsed_response
    end
  end

  def show
    result = HTTParty.get("https://api.themoviedb.org/3/movie/#{params[:id]}?api_key=#{ENV['API_KEY']}")
    if @movie = Movie.find_by(api_id: result["id"])
      @movie
    else
      @movie = Movie.create(
        api_id: result["id"],
        title: result["original_title"],
        synopsis: result["overview"],
        year: result["release_date"],
        cover: "https://www.themoviedb.org/t/p/w1920_and_h1080_bestv2#{result["backdrop_path"]}",
        poster_url: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2#{result["poster_path"]}"
      )
    end
  end

  def create
    @movie = Movie.find_or_initialize_by(api_id: params[:movie][:api_id])
    @movie.assign_attributes(movie_params)
    if @movie.save
      redirect_to new_movie_rating_path(@movie)
    else
      render 'show'
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :poster_url)
  end

end

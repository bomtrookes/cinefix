class MoviesController < ApplicationController
  def index
    query = params[:query].presence || " "
    response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=#{ENV['API_KEY']}&query=#{query}")
    @results = response.parsed_response
  end

  def show
    @movie = Movie.new
    result = HTTParty.get("https://api.themoviedb.org/3/movie/#{params[:id]}?api_key=#{ENV['API_KEY']}")
    @movie.title = result["original_title"]
    @movie.synopsis = result["overview"]
    @movie.year = result["release_date"]
    @movie.poster_url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2#{result["poster_path"]}"
  end

end

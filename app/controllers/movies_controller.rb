class MoviesController < ApplicationController
  def index
    query = params[:query].presence || " "
    response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=#{ENV['API_KEY']}&query=#{query}")
    @results = response.parsed_response
  end

  def show
    if params[:id] == 'search'
      @movies = Movie.search(params[:query])
      render 'index'
    else
      @movie = Movie.find(params[:id])
    end
  end

  def search
    query = params[:query]
    @results = Tmdb::Movie.find(query)
    respond_to do |format|
      format.js # render a JavaScript response for AJAX requests
    end
  end

end

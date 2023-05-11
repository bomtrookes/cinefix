class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def search
    query = params[:query]
    @results = Theomdb::Api.search(query)
    respond_to do |format|
      format.js # render a JavaScript response for AJAX requests
    end
  end

end

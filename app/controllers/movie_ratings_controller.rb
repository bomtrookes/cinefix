class MovieRatingsController < ApplicationController
  def index
    @movie_ratings = MovieRating.includes(:user, :movie, :rating).all
  end
end

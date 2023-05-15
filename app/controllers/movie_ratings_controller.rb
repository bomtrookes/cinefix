class MovieRatingsController < ApplicationController
  def index
    @user = current_user
    @movie_ratings = Movie.all
  end
end

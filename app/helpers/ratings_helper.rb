module RatingsHelper
  def tmdb_movie(movie_id)
    Tmdb::Movie.detail(movie_id)
  end
end

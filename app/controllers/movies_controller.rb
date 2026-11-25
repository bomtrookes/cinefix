class MoviesController < ApplicationController

  def index
    @query = params[:query].to_s.strip
    @default = helpers.asset_path("default-user.jpg")
    @following_ids = current_user ? current_user.followings.pluck(:id) : []

    if @query.present?
      # TMDB orders by popularity; SearchRank moves close name matches to the top.
      @movies = SearchRank.sort(Array(Tmdb::Search.movie(@query)["results"]).first(20), @query) { |m| [m.title, m.original_title] }
      @people = SearchRank.sort(Array(Tmdb::Search.person(@query)["results"]).first(20), @query, &:name)
      @users  = SearchRank.sort(User.search_users(@query).limit(20).to_a, @query, &:username)

      movie_ids = @movies.map(&:id)
      if current_user
        @my_scores = current_user.ratings.where(api_id: movie_ids).to_h { |r| [r.api_id, r.total_score] }
        @my_watchlist = current_user.watchlists.where(api_id: movie_ids).pluck(:api_id)
      end
    else
      @popular = Array(Tmdb::Movie.popular["results"]).sort_by { |movie| -movie.popularity.to_f }.first(12)
      @suggested = suggested_users
    end
    @my_scores ||= {}
    @my_watchlist ||= []
  end

 def show
  @user = current_user
  @rating = current_user&.ratings&.find_by(api_id: params[:id])
  @watchlist = Watchlist.new
  @movie = Tmdb::Movie.detail(params[:id])

  @tmdb_cast = Tmdb::Movie.cast(params[:id])
  @tmdb_crew = Tmdb::Movie.crew(params[:id])

  @tmdb_similar = Tmdb::Movie.similar(params[:id])["results"]
  @tmdb_recommend = Tmdb::Movie.recommendations(params[:id])["results"]
 end

  private

  # Most active raters the current user doesn't already follow
  def suggested_users
    excluded = @following_ids + [current_user&.id].compact
    User.where.not(id: excluded)
        .left_joins(:ratings)
        .group("users.id")
        .order(Arel.sql("COUNT(ratings.id) DESC"))
        .limit(4)
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :poster_url)
  end

end

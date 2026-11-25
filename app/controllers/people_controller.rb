class PeopleController < ApplicationController
  # A cast or crew member's page: who they are, and their films as posters
  def show
    @person = Tmdb::Person.detail(params[:id].to_i, append_to_response: "movie_credits")
    @filmography = Filmography.new(@person.movie_credits)
    @default_group = @filmography.default_group(@person.known_for_department)

    film_ids = @filmography.film_ids
    if current_user
      @my_scores = current_user.ratings.where(api_id: film_ids).to_h { |r| [r.api_id, r.total_score] }
      @my_watched = current_user.watched_films.where(watched: true, api_id: film_ids).distinct.pluck(:api_id)
    end
    @my_scores ||= {}
    @my_watched ||= []
  rescue Tmdb::Error
    handle_routing_error
  end
end

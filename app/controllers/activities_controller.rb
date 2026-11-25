class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def feed
    @activities = current_user.feed_activities
    @films = FilmDetail.for(@activities.map { |activity| activity[:rating].api_id })
  end
end

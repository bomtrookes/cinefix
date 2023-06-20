class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def feed
    @activities = current_user.feed_activities
  end
end

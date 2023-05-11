class ApplicationController < ActionController::Base
  Tmdb::Api.key(ENV["API_KEY"])
end

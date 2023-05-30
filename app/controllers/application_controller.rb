class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  Tmdb::Api.key(ENV["API_KEY"])


  def handle_routing_error
    render plain: "404 Not Found", status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
  end

end

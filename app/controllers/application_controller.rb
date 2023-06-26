class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?

  Tmdb::Api.key(ENV["API_KEY"])

  def handle_routing_error
    respond_to do |format|
      format.html { render 'errors/not_found', status: :not_found }
      format.all { render plain: '404 Not Found', status: :not_found }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end

end

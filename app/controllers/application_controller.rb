class ApplicationController < ActionController::Base
  before_action :require_password_change
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

  private
  def require_password_change
    return unless user_signed_in? && current_user.must_change_password?
    return if devise_controller?
    redirect_to edit_user_registration_path, alert: "Please choose your own password to continue."
  end
end

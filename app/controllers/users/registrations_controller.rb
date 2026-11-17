class Users::RegistrationsController < Devise::RegistrationsController
  before_action :block_demo_user, only: [:edit, :update, :destroy]

  def update
    super do |user|
      if user.errors.empty? && params.dig(:user, :password).present?
        user.update_column(:must_change_password, false)
      end
    end
  end

  private

  def block_demo_user
    if current_user&.demo?
      redirect_to root_path, alert: "The demo account can't be changed."
    end
  end
end

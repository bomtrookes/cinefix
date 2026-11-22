class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def new
    @user = User.new
  end

  def create
    @temp_password = SecureRandom.alphanumeric(12)
    @user = User.new(user_params.merge(
      password: @temp_password,
      password_confirmation: @temp_password,
      must_change_password: true
    ))

    if @user.save
      render :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username)
  end

  def require_admin
    redirect_to root_path, alert: "Admins only." unless current_user.admin?
  end
end

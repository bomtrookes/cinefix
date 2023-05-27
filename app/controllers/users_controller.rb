class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.id != params[:id].to_i
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def edit
    @user = current_user
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  def show
    if current_user.id != params[:id].to_i
      @user = User.find(params[:id])
    else
      @user = current_user
    end
      @ratings = Rating.where(user_id: @user).sort_by { |r| -r.total_score }
  end

  def edit
    @user = current_user
  end
end

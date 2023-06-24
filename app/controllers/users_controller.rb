class UsersController < ApplicationController
  before_action :authenticate_user!

  def following
    @user = User.find(params[:id])
    @users = @user.followings

  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers

  end

  def show
    @default = "https://res.cloudinary.com/dzxuvey8d/image/upload/v1660399373/default-user_cdb0ks.jpg"
    if current_user.id != params[:id].to_i
      @user = User.find(params[:id])
    else
      @user = current_user
    end
      @ratings = Rating.where(user_id: @user).sort_by { |r| -r.total_score }
      @recent = @ratings.sort_by { |r| -r.created_at.to_i }.first(4)
  end

  def edit
    @user = current_user
  end
end

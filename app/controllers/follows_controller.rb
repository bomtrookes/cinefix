class FollowsController < ApplicationController
  before_action :set_user

  def following
    @followings = @user.followings
    # @followings = @user.followings.sort_by {|following| following.size }.reverse!
  end

  def followers
    @followers = @user.followers
    # @followers = @user.followers.sort_by {|follower| follower.size }.reverse!
  end

  def create
    @user.followers << current_user

    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  def destroy
    @follow = Follow.find_by(follower_id: current_user.id, followed_user_id: @user.id)
    @follow.destroy

    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  private

  def set_user
    if params[:user_id] == current_user.id
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
  end
end

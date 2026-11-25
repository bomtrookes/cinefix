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
    @user = current_user.id == params[:id].to_i ? current_user : User.find(params[:id])
    @ratings = @user.ratings.to_a.sort_by { |r| [-r.total_score, -r.created_at.to_i] }
    @films = FilmDetail.for(@ratings.map(&:api_id))
    @rank = Rank.progress(@ratings.size)
    @genres = @ratings.flat_map { |r| @films[r.api_id]&.genre_names || [] }
                      .tally.sort_by { |name, count| [-count, name] }.map(&:first)
    @following = current_user.followings.exists?(@user.id)
  end

  def edit
    @user = current_user
  end
end

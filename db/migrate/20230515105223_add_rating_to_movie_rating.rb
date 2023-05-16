class AddRatingToMovieRating < ActiveRecord::Migration[7.0]
  def change
    add_column :movie_ratings, :user_rating, :float
  end
end

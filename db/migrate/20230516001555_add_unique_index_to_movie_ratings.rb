class AddUniqueIndexToMovieRatings < ActiveRecord::Migration[7.0]
  def change
    add_index :movie_ratings, [:movie_id, :user_id, :rating_id], unique: true
  end
end

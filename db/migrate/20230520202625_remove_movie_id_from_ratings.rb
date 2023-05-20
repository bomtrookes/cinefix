class RemoveMovieIdFromRatings < ActiveRecord::Migration[7.0]
  def change
    remove_column :ratings, :movie_id
  end
end

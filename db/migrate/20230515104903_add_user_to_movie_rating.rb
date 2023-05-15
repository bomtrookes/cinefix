class AddUserToMovieRating < ActiveRecord::Migration[7.0]
  def change
    add_reference :movie_ratings, :user, null: false, foreign_key: true
  end
end

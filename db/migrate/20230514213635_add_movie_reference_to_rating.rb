class AddMovieReferenceToRating < ActiveRecord::Migration[7.0]
  def change
    add_reference :ratings, :movie, null: false, foreign_key: true
  end
end

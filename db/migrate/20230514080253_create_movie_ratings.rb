class CreateMovieRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :movie_ratings do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :rating, null: false, foreign_key: true
      t.float :rating
      t.text :review
      t.timestamps
    end
  end
end

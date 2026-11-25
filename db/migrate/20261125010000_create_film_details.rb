# A local copy of the few TMDB details our list pages show (title, release
# date, poster), so those pages stop calling TMDB once per film on every load.
class CreateFilmDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :film_details do |t|
      t.integer :api_id, null: false
      t.string :title, null: false
      t.date :release_date
      t.string :poster_path
      t.timestamps
    end
    add_index :film_details, :api_id, unique: true
  end
end

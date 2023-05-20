class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.date :year
      t.text :synopsis
      t.string :poster_url
      t.string :genres, array: true, default: [], using: "(string_to_array(genres, ','))"
      t.string :cover
      t.float :rating
      t.timestamps
    end
  end
end

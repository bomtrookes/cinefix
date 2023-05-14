class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.date :year
      t.text :synopsis
      t.string :poster_url
      t.string :genre
      t.integer :api_id

      t.timestamps
    end
  end
end

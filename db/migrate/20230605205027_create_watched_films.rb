class CreateWatchedFilms < ActiveRecord::Migration[7.0]
  def change
    create_table :watched_films do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :api_id
      t.boolean :watched

      t.timestamps
    end
  end
end

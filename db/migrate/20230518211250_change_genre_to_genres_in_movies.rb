class ChangeGenreToGenresInMovies < ActiveRecord::Migration[7.0]
  def change
    rename_column :movies, :genre, :genres
    change_column :movies, :genres, :string, array: true, default: [], using: "(string_to_array(genres, ','))"
  end
end

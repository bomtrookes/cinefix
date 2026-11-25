# Genre names for each cached film, so the profile page can filter ratings
# by genre without calling TMDB. NULL means "not fetched yet": FilmDetail.for
# refetches those rows once and fills them in.
class AddGenresToFilmDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :film_details, :genres, :string, array: true
  end
end

class AddCoverToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :cover, :string
  end
end

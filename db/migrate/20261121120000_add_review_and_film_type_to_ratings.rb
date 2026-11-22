class AddReviewAndFilmTypeToRatings < ActiveRecord::Migration[7.0]
  def change
    add_column :ratings, :review, :text
    add_column :ratings, :spoilers, :boolean, default: false, null: false
    add_column :ratings, :film_type, :string, default: "feature", null: false
  end
end

class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.integer :story
      t.integer :acting
      t.integer :dialog
      t.integer :cinematography
      t.integer :soundtrack
      t.integer :style
      t.integer :pacing
      t.integer :originality
      t.integer :characters
      t.integer :enjoyment
      t.timestamps
    end
  end
end

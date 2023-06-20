class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :subject, polymorphic: true
      t.timestamps
    end
  end
end

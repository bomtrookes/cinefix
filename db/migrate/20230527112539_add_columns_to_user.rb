class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username,   :string
    add_column :users, :avatar, :string, default: "https://res.cloudinary.com/dzxuvey8d/image/upload/v1660399373/default-user_cdb0ks.jpg"
  end
end

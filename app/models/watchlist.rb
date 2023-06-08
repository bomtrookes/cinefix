class Watchlist < ApplicationRecord
  belongs_to :user

  validates :api_id, uniqueness: { scope: :user_id }

end

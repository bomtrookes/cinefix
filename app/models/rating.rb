class Rating < ApplicationRecord
  belongs_to :user

  # A score left blank (nil) means the category was marked N/A.
  validates(*RatingCategories::FIELDS,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 10 },
            allow_nil: true)
  validates :api_id, uniqueness: { scope: :user_id }
  validates :film_type, inclusion: { in: RatingCategories::TYPES }
  validates :review, length: { maximum: 5000 }
  validate :not_too_many_na

  before_validation :tidy_review
  after_create :mark_as_watched

  def categories
    RatingCategories.for(film_type)
  end

  def scores
    RatingCategories::FIELDS.map { |field| public_send(field) }.compact
  end

  def na_count
    RatingCategories::FIELDS.count { |field| public_send(field).nil? }
  end

  def documentary?
    film_type == "documentary"
  end

  # Average of the categories that were scored, out of 10.
  def total_score
    return 0 if scores.empty?

    average = scores.sum.to_f / scores.size
    average == 10.0 ? 10 : average.round(1)
  end

  private

  def tidy_review
    self.review = review.to_s.strip.presence
  end

  def not_too_many_na
    return if na_count <= RatingCategories::MAX_NA

    errors.add(:base, "You can mark at most #{RatingCategories::MAX_NA} categories as N/A")
  end

  def mark_as_watched
    user.watched_films.find_or_create_by(api_id: api_id) { |w| w.watched = true }
    user.watchlists.where(api_id: api_id).destroy_all
  end
end

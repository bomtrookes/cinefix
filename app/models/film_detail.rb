# The title, release date and poster of a TMDB film, stored locally.
#
# List pages (profile, ratings, watchlist, watched, feed) used to ask TMDB
# for every film on every page load, one request after another. Now they
# call FilmDetail.for(api_ids): one database query for the films we have
# already seen, and TMDB only for new ones (a few at a time, in parallel),
# which are then saved so the next load needs no TMDB calls at all.
class FilmDetail < ApplicationRecord
  POSTER_BASE = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2".freeze
  PARALLEL_REQUESTS = 8

  # Returns { api_id => FilmDetail } for the given TMDB ids.
  def self.for(api_ids)
    ids = Array(api_ids).compact.map(&:to_i).uniq
    found = where(api_id: ids).index_by(&:api_id)
    missing = ids - found.keys
    return found if missing.empty?

    rows = fetch_from_tmdb(missing)
    upsert_all(rows, unique_by: :api_id) if rows.any?
    found.merge(where(api_id: missing).index_by(&:api_id))
  end

  def self.fetch_from_tmdb(ids)
    ids.each_slice(PARALLEL_REQUESTS).flat_map do |batch|
      batch.map { |id| Thread.new { detail_row(id) } }.map(&:value)
    end.compact
  end

  def self.detail_row(id)
    movie = Tmdb::Movie.detail(id)
    return unless movie.respond_to?(:title) && movie.title.present?

    { api_id: id, title: movie.title,
      release_date: movie.release_date.presence,
      poster_path: movie.poster_path }
  rescue StandardError => e
    Rails.logger.warn("FilmDetail: TMDB lookup failed for #{id}: #{e.message}")
    nil
  end
  private_class_method :fetch_from_tmdb, :detail_row

  def year
    release_date&.year
  end

  def poster_url
    "#{POSTER_BASE}#{poster_path}" if poster_path.present?
  end
end

# A person's films from TMDB (person/:id/movie_credits), grouped by the kind
# of work they did: Acting for cast credits, and TMDB's crew departments
# (Directing, Writing, Production...) for the rest. A film appears once per
# group, with all of that person's roles on it joined together.
class Filmography
  # TMDB department name => what we show on the button
  LABELS = {
    "Camera" => "Cinematography",
    "Crew" => "Other crew",
    "Costume & Make-Up" => "Costume & make-up",
    "Visual Effects" => "Visual effects"
  }.freeze

  # "Thanks" credits are not real work on the film
  SKIP_JOBS = /thanks/i

  Credit = Struct.new(:id, :title, :poster_path, :release_date, :popularity, :roles, keyword_init: true) do
    def year
      release_date.to_s[0, 4].presence
    end

    def date
      Date.parse(release_date.to_s)
    rescue Date::Error
      nil
    end

    def upcoming?
      date.nil? || date > Date.current
    end

    # Used to sort newest first; films with no date go last
    def sort_date
      date ? date.strftime("%Y%m%d").to_i : 0
    end

    def roles_text
      roles.uniq.join(", ").presence
    end
  end

  Group = Struct.new(:key, :label, :credits)

  attr_reader :groups

  def initialize(movie_credits)
    buckets = Hash.new { |hash, key| hash[key] = {} }

    Array(movie_credits&.cast).each do |entry|
      add(buckets["Acting"], entry, entry.character)
    end
    Array(movie_credits&.crew).each do |entry|
      next if entry.job.to_s.match?(SKIP_JOBS)

      add(buckets[entry.department.presence || "Crew"], entry, entry.job)
    end

    @groups = buckets.map do |department, films|
      credits = films.values.sort_by { |credit| -credit.sort_date }
      Group.new(department.parameterize, LABELS.fetch(department, department), credits)
    end
    @groups.sort_by! { |group| -group.credits.size }
  end

  # The group to show first: the person's main job if they have it
  def default_group(known_for_department)
    groups.find { |group| group.key == known_for_department.to_s.parameterize } || groups.first
  end

  def film_ids
    groups.flat_map { |group| group.credits.map(&:id) }.uniq
  end

  def empty?
    groups.empty?
  end

  private

  def add(bucket, entry, role)
    return if entry.id.blank? || entry.title.blank?

    credit = bucket[entry.id] ||= Credit.new(
      id: entry.id, title: entry.title, poster_path: entry.poster_path,
      release_date: entry.release_date, popularity: entry.popularity.to_f, roles: []
    )
    credit.roles << role if role.present?
  end
end

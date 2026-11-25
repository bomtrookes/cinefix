module MoviesHelper

  # Crew jobs shown up front on the movie page, in this order
  KEY_CREW_JOBS = [
    ["Director", ["Director"]],
    ["Writer", ["Screenplay", "Writer", "Story", "Novel", "Author"]],
    ["Music", ["Original Music Composer", "Music"]],
    ["Cinematography", ["Director of Photography"]],
    ["Editor", ["Editor"]],
    ["Producer", ["Producer"]]
  ].freeze

  def format_date(date)
    date == "" ? "" : date.to_date.strftime("%Y")
  end

  # [[label, person], ...] for the key jobs, one row per person per label
  def key_crew(crew)
    KEY_CREW_JOBS.flat_map do |label, jobs|
      crew.select { |person| jobs.include?(person.job) }.uniq(&:id).map { |person| [label, person] }
    end
  end

  # [[jobs, person], ...] for everyone else, one row per person, by department
  def other_crew(crew, key)
    shown = key.map { |_label, person| [person.id, person.job] }
    crew.reject { |person| shown.include?([person.id, person.job]) || person.job.to_s.match?(/thanks/i) }
        .group_by(&:id)
        .map { |_id, credits| [credits.map(&:job).uniq.join(", "), credits.first] }
        .sort_by { |_jobs, person| [person.department.to_s, person.name.to_s] }
  end
end

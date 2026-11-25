# Ranks earned by rating films. Thresholds widen as you climb.
module Rank
  TIERS = [
    [250, "Legend"],
    [100, "Auteur"],
    [50,  "Critic"],
    [25,  "Front Row"],
    [10,  "Regular"],
    [0,   "Ticket Holder"]
  ].freeze

  Progress = Struct.new(:name, :count, :next_name, :next_min, :min, keyword_init: true) do
    def top?
      next_name.nil?
    end

    def remaining
      top? ? 0 : next_min - count
    end

    # How far through the current tier, 0-100.
    def percent
      return 100 if top?

      (((count - min).to_f / (next_min - min)) * 100).round
    end
  end

  def self.for(count)
    TIERS.find { |min, _name| count >= min }.last
  end

  def self.progress(count)
    index = TIERS.index { |min, _name| count >= min }
    min, name = TIERS[index]
    next_min, next_name = index.zero? ? [nil, nil] : TIERS[index - 1]
    Progress.new(name: name, count: count, min: min, next_min: next_min, next_name: next_name)
  end
end

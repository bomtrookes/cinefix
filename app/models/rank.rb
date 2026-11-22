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

  def self.for(count)
    TIERS.find { |min, _name| count >= min }.last
  end
end

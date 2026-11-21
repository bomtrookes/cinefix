# The ten scoring slots on a rating, and what they mean for each type of film.
# The database columns stay the same; a documentary just labels them differently.
module RatingCategories
  FIELDS = %i[story acting dialog cinematography soundtrack style pacing originality characters enjoyment].freeze
  MAX_NA = 3

  SETS = {
    "feature" => {
      name: "Feature",
      categories: {
        story:          ["Story",          "Plot, structure and how well it holds together"],
        acting:         ["Acting",         "Performances across the whole cast"],
        dialog:         ["Dialogue",       "Does the writing sound true and land?"],
        cinematography: ["Cinematography", "Camera work, lighting and framing"],
        soundtrack:     ["Soundtrack",     "Score, songs and sound design"],
        style:          ["Aesthetics",     "Production design, costume and overall look"],
        pacing:         ["Pacing",         "Does it drag or rush?"],
        originality:    ["Originality",    "Fresh ideas, or seen it before?"],
        characters:     ["Characters",     "Do you care about them and believe them?"],
        enjoyment:      ["Enjoyment",      "Simply, how much you enjoyed it"]
      }
    },
    "documentary" => {
      name: "Documentary",
      categories: {
        story:          ["Subject",             "How compelling is the topic itself?"],
        acting:         ["Storytelling",        "How well it is shaped into a narrative"],
        dialog:         ["Research & accuracy", "Does it feel thorough, fair and trustworthy?"],
        cinematography: ["Visuals",             "Footage, archive material and camera work"],
        soundtrack:     ["Sound & score",       "Music, narration and sound design"],
        style:          ["Balance",             "Does it show more than one side where it matters?"],
        pacing:         ["Pacing",              "Does it drag or rush?"],
        originality:    ["Insight",             "Did you learn something or see it differently?"],
        characters:     ["Access",              "How close it gets to the people involved"],
        enjoyment:      ["Enjoyment",           "Simply, how much you enjoyed it"]
      }
    }
  }.freeze

  TYPES = SETS.keys.freeze
  DOCUMENTARY_GENRE_ID = 99 # TMDB genre id for Documentary

  def self.for(film_type)
    SETS.fetch(film_type.to_s, SETS["feature"])[:categories]
  end
end

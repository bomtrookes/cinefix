# Re-orders search results so names that match what was typed come first.
#
# TMDB sorts its search results by popularity, so searching "Home Alone"
# can put sequels and other popular films above the film called exactly
# "Home Alone". We keep TMDB's order, but only within each of these tiers:
#   0. exact match            "home alone"  -> Home Alone
#   1. starts with the query  "home alone"  -> Home Alone 2: Lost in New York
#   2. starts with it mid-word "home alo"   -> Home Alone
#   3. contains every word    "alone home"  -> Home Alone
#   4. everything else
module SearchRank
  module_function

  # names_for returns the name(s) of one result, e.g. title and original title.
  def sort(items, query, &names_for)
    typed = normalize(query)
    return items if typed.empty?

    words = typed.split
    items.each_with_index.sort_by do |item, index|
      names = Array(names_for.call(item)).map { |name| normalize(name) }.reject(&:empty?)
      [tier(names, typed, words), index]
    end.map(&:first)
  end

  def tier(names, typed, words)
    return 0 if names.include?(typed)
    return 1 if names.any? { |name| name.start_with?("#{typed} ") }
    return 2 if names.any? { |name| name.start_with?(typed) }
    return 3 if names.any? { |name| (words - name.split).empty? }

    4
  end

  # "The Lord of the Rings: The Two Towers" -> "lord of the rings the two towers"
  def normalize(text)
    I18n.transliterate(text.to_s).downcase
        .gsub("&", " and ")
        .gsub(/[^a-z0-9]+/, " ")
        .squish
        .delete_prefix("the ")
  end
end

module UsersHelper
  # "today", "21 Nov" this year, "21 Nov 2025" for older dates.
  def rated_on(time)
    date = time.to_date
    return "today" if date == Date.current

    date.strftime(date.year == Date.current.year ? "%-d %b" : "%-d %b %Y")
  end

  # Sort key for A-Z that ignores a leading "The", "A" or "An".
  def title_sort_key(title)
    title.to_s.downcase.sub(/\A(the|a|an)\s+/, "")
  end
end

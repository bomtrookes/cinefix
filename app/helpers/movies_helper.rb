module MoviesHelper

  def format_date(date)
    date == "" ? "" : date.to_date.strftime("%Y")
  end
end

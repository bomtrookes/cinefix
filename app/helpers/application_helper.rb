module ApplicationHelper

  def initials(name)
    name.split.map(&:first).join.upcase
  end
end

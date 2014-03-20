module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    font_awesome_direction = direction == "asc" ? "up" : "down"
    css_class = column == sort_column ? "fa-caret-#{font_awesome_direction}" : nil
    #link_to title, {:sort => column, :direction => direction}, {class: css_class}
    link_to "<i class='fa #{css_class}'></i> ".html_safe+title, {:sort => column, :direction => direction}
  end
end


# frozen_string_literal: true

# Global view helpers
module ApplicationHelper
  def sortable(column, title=nil)
    title ||= column.titleize
    css_class =
      column == sort_column ? "current #{sort_direction}" : nil
    direction =
      column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title,
      params.merge(sort: column, direction: direction, page: nil)
      .permit(:sort, :direction, :page),
      class: css_class
  end

  def render_side_bar
    case controller_name
    when "businesses"
      render "layouts/shared/businesses_side_bar"
    when "reports"
      render "layouts/shared/reports_side_bar"
    end
  end

  def create_nav_link(text, path)
    class_name = current_page?(path) ? "nav-item active" : "nav-item"

    content_tag(:li, class: class_name) do
      link_to text, path, class: "nav-link"
    end
  end

  def create_subnav_link(text, path)
    class_name = current_page?(path) ? "nav-link active" : "nav-link"

    content_tag(:li, class: "nav-item") do
      link_to text, path, class: class_name
    end
  end

  def render_time(created_at)
    "#{time_ago_in_words(created_at, include_seconds: true)} ago"
  end
end

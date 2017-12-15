module DashboardHelper
  def render_panel_footer(path)
    link_to path do
      content_tag :div, class: 'panel-footer' do
        concat(content_tag :span, "View Details", class: "pull-left")
        content_tag :span, class: 'pull-right' do
          content_tag :i, class: "fa fa-arrow-circle-right"
        end
        concat(content_tag :div, "", class: "clearfix")
      end
    end
  end
end

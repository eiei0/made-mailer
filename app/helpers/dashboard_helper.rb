# View helpers for dashboard templates
module DashboardHelper
  # rubocop:disable Metrics/LineLength
  def render_panel_footer(path)
    link_to path do
      content_tag :div, class: 'panel-footer' do
        concat(content_tag(:span, 'View Details', class: 'pull-left'))
        concat(content_tag(:span, content_tag(:i, '', class: 'fa fa-arrow-circle-right'), class: 'pull-right'))
        concat(content_tag(:div, '', class: 'clearfix'))
      end
    end
  end
  # rubocop:enable Metrics/LineLength
end

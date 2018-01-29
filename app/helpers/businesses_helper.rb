# View helpers for business templates
module BusinessesHelper
  def render_buttons_panel(business)
    if show_buttons?(business)
      render partial: 'buttons', locals: { business: business }
    else
      render partial: 'no_options'
    end
  end

  def render_followup_mailer_button(business)
    return unless business.last_order_placed.present?
    button_to(
      'send followup mailer',
      mailers_path(business_id: business.id),
      params: { type: 'post_purchase_check_in', deliver_now: true },
      class: 'btn btn-info'
    )
  end

  def render_stop_mailers_button(business)
    return unless business.scheduled? || business.responded?
    button_tag(
      'Stop All Automated Mailers',
      class: 'btn btn-danger',
      'data-toggle' => 'modal',
      'data-target' => '#stopBusinessMailers'
    )
  end

  def show_buttons?(business)
    business.last_order_placed.present? || !business.responded?
  end

  def render_status_type(business)
    return if business.status?
    button_to(
      business.status.humanize.titleize.to_s,
      business_path(business),
      method: :get,
      class: "btn btn-sm btn-outline #{status_type(business)}"
    )
  end

  def status_type(business)
    types = Hash[
      pending: 'btn-warning',
      current_wholesale_vendor: 'btn-success',
      current_consignment_vendor: 'btn-success',
      declined: 'btn-danger',
      followup_later: 'btn-primary',
      response_received: 'btn-info',
      unresponsive: 'btn-danger']
    types[business.status.to_sym]
  end
end

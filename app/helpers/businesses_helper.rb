module BusinessesHelper
  def render_buttons_panel(business)
    if show_buttons?(business)
      render partial: 'buttons', locals: { business: business }
    else
      render partial: 'no_options'
    end
  end

  def render_followup_mailer_button(business)
    if business.last_order_placed.present?
      button_to "send followup mailer", mailers_path(business_id: business.id), { params: { type: "post_purchase_check_in", deliver_now: true }, class: 'btn btn-info' }
    end
  end

  def render_stop_mailers_button(business)
    unless business.responded?
      button_tag "Stop All Automated Mailers", class: 'btn btn-danger', "data-toggle"=>"modal", 'data-target'=>'#stopBusinessMailers'
    end
  end

  def show_buttons?(business)
    business.last_order_placed.present? || !business.responded?
  end

  def render_status_type(business)
    if business.status?
      button_to "#{business.status.humanize.titleize}", business_path(business), method: :get, class: "btn btn-sm btn-outline #{status_type(business)}"
    end
  end

  def status_type(business)
    case business.status
    when "pending"
      "btn-warning"
    when "current_wholesale_vendor"
      "btn-success"
    when "current_consignment_vendor"
      "btn-success"
    when "declined"
      "btn-danger"
    when "followup_later"
      "btn-primary"
    when "response_received"
      "btn-info"
    when "unresponsive"
      "btn-danger"
    end
  end
end

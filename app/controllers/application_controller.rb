# frozen_string_literal: true

# Rails
class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :disable_top_bar, :disable_side_bar
  before_action :set_raven_context

  helper_method :sort_column, :sort_direction

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[first last email password password_confirmation]
    )
  end

  def disable_top_bar
    @disable_top_bar = current_user.present?
  end

  def disable_side_bar
    @disable_side_bar = current_user.present?
  end

  private

  def sort_column
    return params[sort] if Business.column_names.include?(params[:sort])

    "last_contacted_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id], foo: :bar)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :disable_top_bar, :disable_side_bar
  protect_from_forgery prepend: true

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first, :last, :email, :password, :password_confirmation])
  end

  def disable_top_bar
    @disable_top_bar = current_user.present?
  end

  def disable_side_bar
    @disable_side_bar = current_user.present?
  end
end

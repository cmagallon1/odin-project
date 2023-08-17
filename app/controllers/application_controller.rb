# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :configure_permitted_parametters, if: :devise_controller?

  protected

  def configure_permitted_parametters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name])
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :devise_controller?

  def render_failure(object)
    render 'shared/failure', locals: { object: object }
  end

  def family_view?
    params[:family]
  end
  helper_method :family_view?
end

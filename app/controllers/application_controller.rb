class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :devise_controller?

  def render_failure(object)
    render 'shared/failure', locals: { object: object }
  end

  def current_scope
    @current_scope ||= family_view? ? current_user.family : current_user
  end

  def family_view?
    params[:family] == 'true' || params[:family] == true
  end
  helper_method :family_view?
end

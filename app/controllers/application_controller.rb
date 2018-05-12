class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_failure(object)
    render 'shared/failure', locals: { object: object }
  end
end

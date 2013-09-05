class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.

  before_filter :check_uri_host

  def check_uri_host
    # TODO request test
    if Rails.env == 'production' && !params[:no_redirect] && request.host != 'lyrem-ipsum.com'
      redirect_to request.protocol + request.host_with_port + request.request_uri
    end
  end

end


class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::MimeResponds

  # Disable CSRF because this is an API
  protect_from_forgery with: :null_session if respond_to?(:protect_from_forgery)
end

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Devise::Controllers::Helpers   # allows current_user, authenticate_user!, etc.
  respond_to :json

  # If you want to protect globally:
  # before_action :authenticate_user!
end

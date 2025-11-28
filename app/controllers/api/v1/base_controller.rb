# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ApplicationController
      # Use devise helpers (ApplicationController includes them already)
      before_action :authenticate_user!   # protect endpoints by default

      respond_to :json

      protected

      # helpers to keep controllers consistent for naming used earlier
      def authenticate_api_v1_user!
        authenticate_user!
      end

      def current_api_v1_user
        current_user
      end
    end
  end
end

module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!
      respond_to :json

      protected

      def authenticate_api_v1_user!
        authenticate_user!
      end

      def current_api_v1_user
        current_user
      end
    end
  end
end

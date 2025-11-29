# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < BaseController
      def me
        render json: {
          id: current_user.id,
          email: current_user.email,
          created_at: current_user.created_at
        }, status: :ok
      end
    end
  end
end

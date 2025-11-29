# app/controllers/api/v1/users/sessions_controller.rb
module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        # LOGIN
        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)

          token = request.env['warden-jwt_auth.token']

          render json: {
            message: "Logged in successfully",
            token: token,
            user: {
              id: resource.id,
              email: resource.email
            }
          }, status: :ok
        end

        # LOGOUT
        def respond_to_on_destroy
          render json: { message: "Logged out successfully" }, status: :ok
        end
      end
    end
  end
end

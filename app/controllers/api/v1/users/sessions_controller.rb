# app/controllers/api/v1/users/sessions_controller.rb
module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        # Login/logout must be public
        skip_before_action :authenticate_user!, raise: false

        # No HTML redirect behavior
        protected def verify_signed_out_user; end

        # POST /auth/sign_in
        # Devise + devise-jwt will set request.env['warden-jwt_auth.token']
        def create
          super
        end

        private

        def respond_with(resource, _opts = {})
          token = request.env['warden-jwt_auth.token']
          render json: {
            message: "Logged in successfully",
            token: token,
            user: { id: resource.id, email: resource.email }
          }, status: :ok
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end

# app/controllers/api/v1/users/registrations_controller.rb
module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        # Public: allow creating account without authentication
        skip_before_action :authenticate_user!, raise: false

        # No HTML redirect behavior for APIs
        protected def verify_signed_out_user; end

        # POST /auth  (routes.map to this path)
        def create
          build_resource(sign_up_params)

          if resource.save
            render json: {
              message: "User created successfully",
              user: { id: resource.id, email: resource.email }
            }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end

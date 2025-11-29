module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        skip_before_action :authenticate_user!, raise: false

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

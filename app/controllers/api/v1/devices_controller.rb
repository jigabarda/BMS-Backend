# app/controllers/api/v1/devices_controller.rb
module Api
  module V1
    class DevicesController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: current_user.devices
      end

      def create
        device = current_user.devices.find_or_initialize_by(push_token: device_params[:push_token])
        device.platform = device_params[:platform]
        if device.save
          render json: device, status: :created
        else
          render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        device = current_user.devices.find(params[:id])
        device.destroy
        head :no_content
      end

      private

      def device_params
        params.require(:device).permit(:push_token, :platform)
      end
    end
  end
end

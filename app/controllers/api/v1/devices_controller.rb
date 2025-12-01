# app/controllers/api/v1/devices_controller.rb
module Api
  module V1
    class DevicesController < BaseController

      # GET /api/v1/devices
      def index
        render json: current_user.devices, status: :ok
      end

      # POST /api/v1/devices
      def create
        # Look for token globally (NOT scoped by current_user)
        device = Device.find_or_initialize_by(token: device_params[:token])

        # Always update the device’s user + platform
        device.user = current_user
        device.platform = device_params[:platform] if device_params[:platform].present?

        if device.save
          render json: device, status: :ok  # use :ok instead of :created to avoid confusion
        else
          render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/devices/:id
      def destroy
        device = current_user.devices.find_by(id: params[:id]) ||
                 current_user.devices.find_by(token: params[:id])

        if device&.destroy
          head :no_content
        else
          render json: { error: "Device not found" }, status: :not_found
        end
      end

      private

      def device_params
        params.require(:device).permit(:token, :platform)
      end
    end
  end
end

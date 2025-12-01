# app/controllers/api/v1/broadcasts_controller.rb
module Api
  module V1
    class BroadcastsController < BaseController
      before_action :ensure_json_request
      before_action :set_broadcast, only: [:show, :send_broadcast]

      # GET /api/v1/broadcasts
      def index
        broadcasts = current_user.broadcasts.order(created_at: :desc)
        render json: broadcasts, status: :ok
      end

      # GET /api/v1/broadcasts/:id
      def show
        render json: @broadcast, status: :ok
      end

      # POST /api/v1/broadcasts
      def create
        broadcast = current_user.broadcasts.new(
          broadcast_params.merge(status: "pending")
        )

        if broadcast.save
          render json: broadcast, status: :created
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/broadcasts/:id
      def update
        broadcast = current_user.broadcasts.find(params[:id])

        if broadcast.update(broadcast_params)
          render json: broadcast, status: :ok
        else
          render json: { errors: broadcast.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/broadcasts/:id
      def destroy
        broadcast = current_user.broadcasts.find(params[:id])
        broadcast.destroy
        head :no_content
      end

      # POST /api/v1/broadcasts/:id/send_broadcast
      def send_broadcast
        Rails.logger.info "[BroadcastsController#send_broadcast] user=#{current_user.id} broadcast_id=#{@broadcast.id}"

        # Always allow re-send
        @broadcast.update!(
          status: "sent",
          sent_at: Time.current
        )

        tokens = current_user.devices.pluck(:token).compact
        Rails.logger.info "[BroadcastsController] Sending push to #{tokens.count} devices"

        begin
          PushNotificationSender.send_notification(tokens, {
            title: @broadcast.title,
            body: @broadcast.message,
            broadcast_id: @broadcast.id
          })
        rescue => e
          Rails.logger.error "PushNotificationSender error: #{e.class} #{e.message}"
        end

        render json: { status: "sent", pushed_to: tokens.count }, status: :ok
      end

      private

      def ensure_json_request
        return if request.format.json?
        render json: { error: "JSON format required" }, status: :not_acceptable
      end

      def set_broadcast
        @broadcast = current_user.broadcasts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Broadcast not found" }, status: :not_found
      end

      def broadcast_params
        params.require(:broadcast).permit(:title, :message)
      end
    end
  end
end
